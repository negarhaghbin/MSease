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

class ARViewController: UIViewController {
    @IBOutlet var arview : ARView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addMascotButton: UIButton!
    
    let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
    
    let coachingOverlay = ARCoachingOverlayView()
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    var mascotsViewController: MascotSelectionViewController?
    
    var cards : [[Entity]] = []
    var tappedCards : [[Entity]] = []
    var currentTappedCardIndices : (Int, Int)?
    var selectedLimb : limb?
    
    var availableMascots : [Mascot] {
        var mascots : [Mascot] = []
        for mascotName in mascotNames{
            let mascot = Mascot()
            mascot.name = mascotName
            
            mascots.append(mascot)
        }
        return mascots
    }
    
    var loadedMascot : ModelEntity?
    var session: ARSession {
        return arview.session
    }
    
    var isLoading = false
    var isRestartAvailable = true
    
    enum SegueIdentifier: String {
        case showMascots
    }
    
    var selectedMascotIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        arview.delegate = self
//        arview.session.delegate = self
        setupCoachingOverlay()

//        arview.scene.rootNode.addChildNode(focusSquare)

        statusViewController.restartExperienceHandler = { [unowned self] in
//            self.restartExperience()
        }
        
        arview.scene.addAnchor(anchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        session.pause()
    }

    // MARK: - Session management
    
    func resetTracking() {
//        selectedMascot = nil
//        
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        if #available(iOS 12.0, *) {
//            configuration.environmentTexturing = .automatic
//        }
//        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Point the camera to your \(selectedLimb?.rawValue ?? "") to place grid", inSeconds: 7.5, messageType: .planeEstimation)
    }
    
    
    func createGrid(completionHandler: ([(Int, Int)])->()){
        var row = 0
        var col = 0
        var hidden : [(Int, Int)]?
        switch selectedLimb{
        case .none:
            print("unknown limb")
        case .abdomen:
            row = LimbGridSize.abdomen.row
            col = LimbGridSize.abdomen.col
            hidden = LimbGridSize.abdomen.hidden
            
        case .leftThigh, .rightThigh:
            row = LimbGridSize.thigh.row
            col = LimbGridSize.thigh.col
            hidden = LimbGridSize.thigh.hidden

        case .leftArm, .rightArm:
            row = LimbGridSize.arm.row
            col = LimbGridSize.arm.col
            hidden = []
            
        case .leftButtock:
            row = LimbGridSize.leftButtock.row
            col = LimbGridSize.leftButtock.col
            hidden = LimbGridSize.leftButtock.hidden
            
        case .rightButtock:
            row = LimbGridSize.rightButtock.row
            col = LimbGridSize.rightButtock.col
            hidden = LimbGridSize.rightButtock.hidden
        }
        
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
        
        completionHandler(hidden!)
    }
    
    func placeGrid(hidden: [(Int, Int)]){
        for (i,cardRow) in cards.enumerated(){
            for (j, card) in cardRow.enumerated(){
                if hidden.contains(where: {
                    return i==$0 && j == $1
                }){
                    continue
                }
                card.position = [Float(j)*0.035, 0, Float(i)*0.035]
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
    
    func turnLastTappedCell(){
        anchor.addChild(cards[currentTappedCardIndices!.0][currentTappedCardIndices!.1])
        anchor.removeChild(tappedCards[currentTappedCardIndices!.0][currentTappedCardIndices!.1])
    }
    
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arview)
        if loadedMascot == nil {
            statusViewController.scheduleMessage("Select a mascot.", inSeconds: 7.5, messageType: .mascotSelection)
            return
        }
        
        if anchor.children.count == 0{
            createGrid(completionHandler: { hidden in
                placeGrid(hidden: hidden)
                if let mascot = loadedMascot{
                    placeMascot(mascot)
                }
            })
        }
        
        else if let card = arview.entity(at: tapLocation){
            if let indices = indices(of: card, in: cards){
                if currentTappedCardIndices != nil{
                    turnLastTappedCell()
                }
                anchor.addChild(tappedCards[indices.0][indices.1])
                currentTappedCardIndices = indices
                anchor.removeChild(card)
            }
            else if let indices = indices(of: card, in: tappedCards){
                anchor.addChild(cards[indices.0][indices.1])
                anchor.removeChild(card)
                currentTappedCardIndices = nil
            }
            else{
                print("unknown object tapped")
            }
//            if card.transform.rotation.angle == .pi{
//                var flipDownTransform = card.transform
//                flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
//                card.move(to: flipDownTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
//            }
//            else{
//                var flipUpTransform = card.transform
//                flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
//                card.move(to: flipUpTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
//            }
            
            
            
        }
        
    }
    
    @IBAction func showMascotSelectionViewController() {
        guard !addMascotButton.isHidden && !isLoading else { return }
        
        statusViewController.cancelScheduledMessage(for: .contentPlacement)
        performSegue(withIdentifier: SegueIdentifier.showMascots.rawValue, sender: addMascotButton)
    }
    
    // MARK: Mascot anchors
    func addOrUpdateAnchor(for object: ModelEntity) {
        if let anchor = object.anchor {
            //might need updating the view
            arview.scene.removeAnchor(anchor)
//            session.remove(anchor: anchor)
        }
        
        let newAnchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
//        let newAnchor = ARAnchor(transform: object.simdWorldTransform)
        newAnchor.addChild(object)
//        object.anchor = newAnchor
        arview.scene.addAnchor(newAnchor)
//        session.add(anchor: newAnchor)
    }
    
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
