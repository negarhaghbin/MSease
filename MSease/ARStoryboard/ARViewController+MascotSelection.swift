/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Methods on the main view controller for handling virtual object loading and movement
*/

import UIKit
import ARKit
import RealityKit

extension ARViewController : MascotSelectionViewControllerDelegate {

    // MARK: - MascotSelectionViewControllerDelegate
    func mascotSelectionViewController(_: MascotSelectionViewController, didSelectObjectAt index: Int) {
        loadMascot(at: index, loadedHandler: {
            self.hideObjectLoadingUI()
        })
        displayObjectLoadingUI()
    }
    
    func mascotSelectionViewController(_: MascotSelectionViewController, didDeselectObjectAt index: Int) {
        removeMascot(at: index)
    }

    // MARK: Object Loading UI

    func displayObjectLoadingUI() {
        spinner.startAnimating()
        
        addMascotButton.setImage(#imageLiteral(resourceName: "ring"), for: [])

        addMascotButton.isEnabled = false
        isRestartAvailable = false
    }

    func hideObjectLoadingUI() {
        spinner.stopAnimating()

        addMascotButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addMascotButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])

        addMascotButton.isEnabled = true
        isRestartAvailable = true
    }
}
