//
//  BottomContainerViewController + MascotSelectionViewControllerDelegate.swift
//  MSease
//
//  Created by Negar on 2021-03-04.
//

import UIKit
import ARKit
import RealityKit

extension BottomContainerViewController : MascotSelectionViewControllerDelegate {

    // MARK: - MascotSelectionViewControllerDelegate
    func mascotSelectionViewController(_: MascotSelectionViewController, didSelectObjectAt index: Int) {
        
        let parent = self.parent as! ARViewController
        parent.loadMascot(at: index, loadedHandler: {
            DispatchQueue.main.async {
                parent.hideObjectLoadingUI()
            }
        })
        parent.displayObjectLoadingUI()
    }
    
    func mascotSelectionViewController(_: MascotSelectionViewController, didDeselectObjectAt index: Int) {
        
        let parent = self.parent as! ARViewController
        parent.removeMascot(at: index)
    }
}
