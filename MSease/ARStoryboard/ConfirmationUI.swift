//
//  ConfirmationUI.swift
//  MSease
//
//  Created by Negar on 2021-03-08.
//

import UIKit

extension ARViewController{
    func showConfirmationUI(){
        for child in children{
            if let childVC = child as? BottomContainerViewController{
                childVC.addMascotButtonEffectView.isHidden = true
                childVC.exitEffectView.isHidden = true
                childVC.doneEffectView.isHidden = false
            }
        }
    }
    
    func hideConfirmationUI(){
        for child in children{
            if let childVC = child as? BottomContainerViewController{
                childVC.addMascotButtonEffectView.isHidden = false
                childVC.exitEffectView.isHidden = false
                childVC.doneEffectView.isHidden = true
            }
        }
    }
    

}
