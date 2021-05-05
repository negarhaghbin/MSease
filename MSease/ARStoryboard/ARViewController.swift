//
//  ARViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-25.
//

import UIKit
import RealityKit
import ARKit
import FocusEntity

class ARViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var arview : ARView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var bottomContainerView: UIView!
    
    // MARK: - Variables
    var partitionValue = RealmManager.shared.getPartitionValue()
    
    let anchor = AnchorEntity(plane: .any, minimumBounds: [0.1, 0.1])
    let coachingOverlay = ARCoachingOverlayView()
    var focusSquare : FocusEntity?
    
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    var cells : [[Entity]] = []
    var tappedCells : [[Entity]] = []
    var currentTappedCellIndices : (Int, Int)?
    
    var loadedMascots : [ModelEntity] = []
    var isLoading = false
    var isRestartAvailable = true
    
    var selectedLimbName : String?
    var injection : Injection?{
        didSet{
            navigationController?.isNavigationBarHidden = true
            UIApplication.shared.isIdleTimerDisabled = false
            performSegue(withIdentifier: "postInjection", sender: nil)
        }
    }
    
    
    var selectedMascotIndex : Int = -1
    
    let parentEntity = ModelEntity()

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view is loading")
        focusSquare = FocusEntity(on: arview, style: .classic(color: .yellow))
        setupCoachingOverlay()
        
        if loadedMascots.count == 0{
            loadMascots()
        }
        
        if selectedMascotIndex == -1{
            for (index, mascot) in mascotNames.enumerated(){
                if mascot.name == RealmManager.shared.getMascot(){
                    selectedMascotIndex = index
                }
            }
        }

        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        presentTutorial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
        
        let bottomViewController = children.lazy.compactMap({ $0 as? BottomContainerViewController }).first!
        bottomViewController.partitionValue = partitionValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view will disappear")
        super.viewWillDisappear(animated)
        arview.session.pause()
    }
    
    deinit{
        focusSquare?.destroy()
        print("deiniting")
        arview.session.delegate = nil
        arview.scene.anchors.removeAll()
        arview.removeFromSuperview()
//        arview.window?.resignKey()
        arview = nil
    }
    
    // MARK: - Tutorial
    
    func presentTutorial(){
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tutorialVC")
        present(vc, animated: true)
    }

    // MARK: - Helper
    
    func resetTracking() {
//        loadedMascot = nil
        arview.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arview.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        print(view.subviews.count)
//        statusViewController.scheduleMessage("Tap to place grid.", inSeconds: 7.5, messageType: .mascotSelection)
        arview.scene.addAnchor(anchor)
    }
    
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
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    func objectLoadingUI(display: Bool) {
        let bottomViewController = children.lazy.compactMap({ $0 as? BottomContainerViewController }).first!
        if display{
            bottomViewController.spinner.startAnimating()
        }
        else{
            bottomViewController.spinner.stopAnimating()
        }
        
        bottomViewController.addMascotButton.isEnabled = !display
        
        isRestartAvailable = !display
    }
    
    func isShowingObjects() -> Bool{
        for child in anchor.children{
            if child == parentEntity{
                return true
            }
        }
        return false
    }
    
    func placeObjects(hidden: [(x: Int, y: Int)]){
        if loadedMascots.count != 0{
            if selectedMascotIndex != -1{
                parentEntity.addChild(loadedMascots[selectedMascotIndex])
            }
        }
            placeGrid(hidden: hidden)
            arview.installGestures([.all], for: parentEntity)
            anchor.addChild(parentEntity)
    }
    
    // MARK: - Actions
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arview)
        
        if !isShowingObjects(){
            objectLoadingUI(display: true)
            createGrid(completionHandler: { hidden in
                placeObjects(hidden: hidden)
                DispatchQueue.main.async {
                    self.objectLoadingUI(display: false)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postInjection"{
            let destinationVC = segue.destination as! postInjectionVC
            destinationVC.injection = injection
        }
    }
    

}
