//
//  ConfirmationUI.swift
//  MSease
//
//  Created by Negar on 2021-03-08.
//

import UIKit

extension ARViewController{
    func showConfirmationUI(){
        let bottomViewController = children.lazy.compactMap({ $0 as? BottomContainerViewController }).first!
        
        bottomViewController.addMascotButtonEffectView.isHidden = true
        bottomViewController.exitEffectView.isHidden = true
        bottomViewController.doneEffectView.isHidden = false
    }
    
    func hideConfirmationUI(){
        let bottomViewController = children.lazy.compactMap({ $0 as? BottomContainerViewController }).first!
        
        bottomViewController.addMascotButtonEffectView.isHidden = false
        bottomViewController.exitEffectView.isHidden = false
        bottomViewController.doneEffectView.isHidden = true
    }
    

}
