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
        print("here")
        if parent.isShowingObjects(){
            if parent.selectedMascotIndex != -1{
                parent.parentEntity.removeChild(parent.loadedMascots[parent.selectedMascotIndex])
            }
            parent.parentEntity.addChild(parent.loadedMascots[index])
        }
        parent.selectedMascotIndex = index
        print(parent.selectedMascotIndex)
        print(index)
    }
    
    func mascotSelectionViewController(_: MascotSelectionViewController, didDeselectObjectAt index: Int) {
        
        let parent = self.parent as! ARViewController
        parent.parentEntity.removeChild(parent.loadedMascots[index])
    }
}
