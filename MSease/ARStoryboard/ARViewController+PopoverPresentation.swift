//
//  ViewController+Actions.swift
//  MSease
//
//  Created by Negar on 2021-01-21.
//

import UIKit
import SceneKit

extension ARViewController: UIPopoverPresentationControllerDelegate {
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        guard let identifier = segue.identifier,
              let segueIdentifer = SegueIdentifier(rawValue: identifier),
              segueIdentifer == .showMascots else { return }
        
        let mascotsViewController = segue.destination as! MascotSelectionViewController
        print(availableMascots)
        mascotsViewController.mascots = availableMascots
        mascotsViewController.delegate = self
        mascotsViewController.sceneView = arview
        self.mascotsViewController = mascotsViewController
        
        mascotsViewController.selectedMascotRow = selectedMascotIndex
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        mascotsViewController = nil
    }
}
