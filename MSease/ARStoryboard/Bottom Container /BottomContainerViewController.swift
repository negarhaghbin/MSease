//
//  BottomContainerViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-04.
//

import UIKit

class BottomContainerViewController: UIViewController {
    
    // MARK: - Variables
    enum SegueIdentifier: String {
        case showMascots
    }
    
    var availableMascots : [Mascot] {
        var mascots : [Mascot] = []
        for mascotName in mascotNames{
            let mascot = Mascot(name: mascotName.name, scale: mascotName.scale)
            mascots.append(mascot)
        }
        return mascots
    }
    var mascotsViewController: MascotSelectionViewController?
    
    var partitionValue: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addMascotButton: UIButton!
    
    @IBOutlet weak var addMascotButtonEffectView: UIVisualEffectView!
    @IBOutlet weak var exitEffectView: UIVisualEffectView!
    @IBOutlet weak var doneEffectView: UIVisualEffectView!
    
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func showMascotSelectionViewController() {
        if let parentVC = parent as? ARViewController{
            guard !addMascotButton.isHidden && !parentVC.isLoading else { return }
            parentVC.statusViewController.cancelScheduledMessage(for: .contentPlacement)
            performSegue(withIdentifier: SegueIdentifier.showMascots.rawValue, sender: addMascotButton)
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        let parentVC = parent as! ARViewController
        parentVC.arview.scene.removeAnchor(parentVC.anchor)
        
        parentVC.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isIdleTimerDisabled = false
        parentVC.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let parentVC = parent as! ARViewController
        parentVC.arview.scene.removeAnchor(parentVC.anchor)
        
        let injection = Injection(limbName: parentVC.selectedLimbName!,
                                  selectedCellX: parentVC.currentTappedCellIndices!.0,
                                  selectedCellY: parentVC.currentTappedCellIndices!.1,
                                  date: Date(), partition: parentVC.partitionValue)

        RealmManager.shared.addInjection(newInjection: injection)
        if parentVC.selectedMascotIndex == -1{
            RealmManager.shared.setMascot(name: "None")
        }
        else{
            RealmManager.shared.setMascot(name: mascotNames[parentVC.selectedMascotIndex].name)
        }
        
        
        parentVC.injection = injection
        
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
