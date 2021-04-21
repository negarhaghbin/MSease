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
    @IBOutlet weak var arview : ARView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    
    let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.1, 0.1])
    
    let coachingOverlay = ARCoachingOverlayView()
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
//    var mascotsViewController: MascotSelectionViewController?
    
    var cells : [[Entity]] = []
    var tappedCells : [[Entity]] = []
    var currentTappedCellIndices : (Int, Int)?
    var selectedLimbName : String?
    var focusSquare : FocusEntity?
    
    var loadedMascot : ModelEntity?
    
    var isLoading = false
    var isRestartAvailable = true
    
    var injection : Injection?{
        didSet{
            navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "postInjection", sender: nil)
//            let storyboard = UIStoryboard(name: "AR", bundle: nil)
//            let postInjection = storyboard.instantiateViewController(withIdentifier: "postInjection") as! postInjectionVC
//
//            self.navigationController?.pushViewController(postInjection, animated: true)
        }
    }
    
    //TODO: save the previous selected mascot in db and put that the default value
    var selectedMascotIndex = -1
    
    var partitionValue = RealmManager.shared.getPartitionValue()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        focusSquare = FocusEntity(on: arview, style: .classic(color: .yellow))
//        arview.delegate = self
//        arview.session.delegate = self
        setupCoachingOverlay()

//        print()
//        arview.scene.rootNode.addChildNode(focusSquare)

        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
//        anchor.addChild(focusSquare)
        
        
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tutorialVC")
        present(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
        
        for child in children{
            if let childVC = child as? BottomContainerViewController{
                childVC.partitionValue = partitionValue
            }
        }
    }
    
    
    //????
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arview.session.pause()
    }

    // MARK: - Helper
    
    func resetTracking() {
        loadedMascot = nil
        arview.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
//        if #available(iOS 12.0, *) {
//            configuration.environmentTexturing = .automatic
//        }
        arview.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        

        statusViewController.scheduleMessage("Select a mascot to begin.", inSeconds: 7.5, messageType: .mascotSelection)
        arview.scene.addAnchor(anchor)
    }
    
    // MARK: - Object Loading UI
    
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
                if cells.count-1 < i{
                    cells.append([])
                }
                cells[i].append(model)
                
                let selectedBoxMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
                let selectedModel = ModelEntity(mesh: box, materials: [selectedBoxMaterial])
                selectedModel.generateCollisionShapes(recursive: true)
                if tappedCells.count-1 < i{
                    tappedCells.append([])
                }
                tappedCells[i].append(selectedModel)
            }
        }
        
        completionHandler(hidden)
    }
    
    func placeGrid(hidden: [(x: Int, y: Int)]){
        for (i,cellRow) in cells.enumerated(){
            for (j, cell) in cellRow.enumerated(){
                if hidden.contains(where: { pair in
                    let result = ((pair.x == i) && (pair.y == j))
                    return result
                }){
                    continue
                }
                /*if j<cellRow.count/2{
                    cell.position = [-Float(j/2)*0.035, 0, Float(i)*0.035]
                }
                else{
                    cell.position = [Float(j/2)*0.035, 0, Float(i)*0.035]
                }*/
                
                let r = cellRow.count%2 == 0 ? Float(0.5) : Float(0)
                
                cell.position = [(Float(j-cellRow.count/2)+r)*0.035, 0, 0.05 + Float(i)*0.035]
                
                tappedCells[i][j].position = cell.position
                anchor.addChild(cell)
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
    
    func selectCell(cell: Entity, index: (Int, Int)){
        anchor.addChild(tappedCells[index.0][index.1])
        currentTappedCellIndices = index
        anchor.removeChild(cell)
    }
    
    func deselectCell(cell: Entity, index: (Int,Int)){
        anchor.addChild(cells[index.0][index.1])
        anchor.removeChild(cell)
        currentTappedCellIndices = nil
    }
    
    func isShowingGrid() -> Bool{
        return anchor.children.count > 1
    }
    
    @IBAction func cellTapped(_ sender: UITapGestureRecognizer) {
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
        
        else if let cell = arview.entity(at: tapLocation){
            if let indices = indices(of: cell, in: cells){
                if currentTappedCellIndices != nil{
                    deselectCell(cell: tappedCells[currentTappedCellIndices!.0][currentTappedCellIndices!.1], index: currentTappedCellIndices!)
                }
                selectCell(cell: cell, index: indices)
                showConfirmationUI()
            }
            else if let indices = indices(of: cell, in: tappedCells){
                deselectCell(cell: cell, index: indices)
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postInjection"{
            let destinationVC = segue.destination as! postInjectionVC
            destinationVC.injection = injection
        }
    }
    

}
