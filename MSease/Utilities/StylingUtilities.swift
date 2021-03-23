//
//  StylingUtilities.swift
//  MSease
//
//  Created by Negar on 2021-03-15.
//

import Foundation
import UIKit

class StylingUtilities{
    static let backgroundColor = "#B7DEEAFF"
    static let buttonColor = "#61A5C2FF"
    
    static func styleTextField(_ textField: UITextField){
        
    }
    
    static func styleFilledButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(hex: buttonColor)
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Futura", size: 17)
    }
    
    static func styleHollowdButton(_ button: UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10.0
        button.tintColor = .black
        button.titleLabel?.font = UIFont(name: "Futura", size: 17)
    }
    
    static func styleView(_ view: UIView){
        view.backgroundColor = UIColor.init(hex: backgroundColor)
    }
}
