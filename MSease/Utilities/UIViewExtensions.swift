//
//  UIView + animation.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import Foundation
import UIKit

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.25, delay: 0, options: [.transitionFlipFromBottom],
                       animations: {
                        self.center.y = (self.superview?.center.y)!
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height*0.8
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
