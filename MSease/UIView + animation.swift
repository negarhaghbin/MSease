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
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromBottom],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
