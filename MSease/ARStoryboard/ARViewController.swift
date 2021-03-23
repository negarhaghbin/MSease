//
//  ARViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-25.
//

import UIKit
import RealityKit
import ARKit
import Combine
import FocusEntity

class ARViewController: UIViewController {
    @IBOutlet var arview : ARView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    
    let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.1, 0.1])
    
    let coachingOverlay = ARCoachingOverlayView()
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
//    var mascotsViewController: MascotSelectionViewController?
    
    var cards : [[Entity]] = []
    var tappedCards : [[Entity]] = []
    var currentTappedCardIndices : (Int, Int)?
    var selectedLimbName : String?
    var focusSquare : FocusEntity?
    
    var loadedMascot : ModelEntity?
    
    var isLoading = false
    var isRestartAvailable = true
    
    //TODO: save the previous selected mascot in db and put that the default value
    var selectedMascotIndex = -1
    
    var partitionValue : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        focusSquare = FocusEntity(on: arview, style: .classic(color: .yellow))
//        arview.delegate = self
//        arview.session.delegate = self
        setupCoachingOverlay()

//        arview.scene.rootNode.addChildNode(focusSquare)

        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
//        anchor.addChild(focusSquare)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        arview.debugOptions.insert(.showStatistics)
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        createGrid(completionHandler: { hidden in
//            placeGrid(hidden: hidden)
//            loadMascots()
//        })
    }
    
    
    //????
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arview.session.pause()
    }

    // MARK: - Session management
    
    func resetTracking() {
        loadedMascot = nil
        arview.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        arview.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        

        statusViewController.scheduleMessage("Select a mascot to begin.", inSeconds: 7.5, messageType: .mascotSelection)
        arview.scene.addAnchor(anchor)
    }
    
    
    func createGrid(completionHandler: ([(x: Int, y: Int)])->()){
        let limb = Limb.getLimb(name: selectedLimbName!)
        let row = limb.numberOfRows
        let col = limb.numberOfCols
        let hidden : [(x: Int, y: Int)] = Array(limb.hiddenCells)
        
        for i in 0..<row{
            for _ in 0..<col{
                let box = MeshResource.generateBox(width: 0.03, height: 0.002, depth: 0.03)
                let cellMaterial = SimpleMaterial(color: UIColor(red: 0.32, green: 0.625, blue: 0.746, alpha: 1), isMetallic: false)
                let model = ModelEntity(mesh: box, materials: [cellMaterial])
                
                
                
                model.generateCollisionShapes(recursive: true)
                if cards.count-1 < i{
                    cards.append([])
                }
                cards[i].append(model)
                
                let selectedBoxMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
                let selectedModel = ModelEntity(mesh: box, materials: [selectedBoxMaterial])
                selectedModel.generateCollisionShapes(recursive: true)
                if tappedCards.count-1 < i{
                    tappedCards.append([])
                }
                tappedCards[i].append(selectedModel)
            }
        }
        
        completionHandler(hidden)
    }
    
    func placeGrid(hidden: [(x: Int, y: Int)]){
        for (i,cardRow) in cards.enumerated(){
            for (j, card) in cardRow.enumerated(){
                if hidden.contains(where: { pair in
                    let result = ((pair.x == i) && (pair.y == j))
                    return result
                }){
                    continue
                }
                /*if j<cardRow.count/2{
                    card.position = [-Float(j/2)*0.035, 0, Float(i)*0.035]
                }
                else{
                    card.position = [Float(j/2)*0.035, 0, Float(i)*0.035]
                }*/
                
                let r = cardRow.count%2 == 0 ? Float(0.5) : Float(0)
                
                card.position = [(Float(j-cardRow.count/2)+r)*0.035, 0, 0.05 + Float(i)*0.035]
                
                tappedCards[i][j].position = card.position
                anchor.addChild(card)
            }
        }
    }
    
    func indices(of x: Entity, in array:[[Entity]]) -> (Int, Int)? {
        for (i, row) in array.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }
        return nil
    }
    
    
    // MARK: Object Loading UI

    func displayObjectLoadingUI() {
        for child in children{
            if let childVC = child as? BottomContainerViewController{
                childVC.spinner.startAnimating()
                childVC.addMascotButton.isEnabled = false
            }
        }
        isRestartAvailable = false
    }

    func hideObjectLoadingUI() {
        for child in children{
            if let childVC = child as? BottomContainerViewController{
                childVC.spinner.stopAnimating()
                childVC.addMascotButton.isEnabled = true
            }
        }
        
        isRestartAvailable = true
    }
    
    func selectCell(card: Entity, index: (Int, Int)){
        anchor.addChild(tappedCards[index.0][index.1])
        currentTappedCardIndices = index
        anchor.removeChild(card)
    }
    
    func deselectCell(card: Entity, index: (Int,Int)){
        anchor.addChild(cards[index.0][index.1])
        anchor.removeChild(card)
        currentTappedCardIndices = nil
    }
    
    func isShowingGrid() -> Bool{
        return anchor.children.count > 1
    }
    
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arview)
        if loadedMascot == nil {
            statusViewController.scheduleMessage("First select a mascot.", inSeconds: 7.5, messageType: .mascotSelection)
            return
        }
        
        if !isShowingGrid(){
            displayObjectLoadingUI()
            createGrid(completionHandler: { hidden in
                placeGrid(hidden: hidden)
                if let mascot = loadedMascot{
                    placeMascot(mascot)
                    DispatchQueue.main.async {
                        self.hideObjectLoadingUI()
                    }
                }
            })
        }
        
        else if let card = arview.entity(at: tapLocation){
            if let indices = indices(of: card, in: cards){
                if currentTappedCardIndices != nil{
                    deselectCell(card: tappedCards[currentTappedCardIndices!.0][currentTappedCardIndices!.1], index: currentTappedCardIndices!)
                }
                selectCell(card: card, index: indices)
                showConfirmationUI()
            }
            else if let indices = indices(of: card, in: tappedCards){
                deselectCell(card: card, index: indices)
                hideConfirmationUI()
            }
        }
        
    }
    
    /*func removeObjects(){
        removeMascot(at: selectedMascotIndex)
        
        arview.scene.removeAnchor(anchor)
    }*/
    
    func restartExperience() {
        guard isRestartAvailable, !isLoading else { return }
        isRestartAvailable = false

        statusViewController.cancelAllScheduledMessages()
        resetTracking()

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
            self.statusContainerView.isHidden = false
        }
    }
    
    // MARK: Mascot anchors
    /*func addOrUpdateAnchor(for object: ModelEntity) {
        if let anchor = object.anchor {
            //might need updating the view
            arview.scene.removeAnchor(anchor)
//            session.remove(anchor: anchor)
        }
        
        let newAnchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.1, 0.1])
//        let newAnchor = ARAnchor(transform: object.simdWorldTransform)
        newAnchor.addChild(object)
//        object.anchor = newAnchor
        arview.scene.addAnchor(newAnchor)
//        session.add(anchor: newAnchor)
    }*/
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        blurView.isHidden = false
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.blurView.isHidden = true
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
