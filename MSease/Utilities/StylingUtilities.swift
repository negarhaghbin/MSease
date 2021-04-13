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
    
    static let noPainColorCode = "#10b5d6ff"
    static let mildPainColorCode = "#4fba82ff"
    static let moderatePainColorCode = "#ffcd2bff"
    static let severePainColorCode = "#f68837ff"
    static let maxPainColorCode = "#f05555ff"
    
    static func styleTextField(_ textField: UITextField){
        
    }
    
    static func styleFilledButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(hex: buttonColor)
        if !button.isEnabled{
            button.backgroundColor = UIColor.gray
        }
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
    
    static func styleDisabledCell(tableCell: UITableViewCell, label: UILabel?, imageView: UIImageView?){
        label?.textColor = UIColor.placeholderText
        imageView?.tintColor  = UIColor.placeholderText
        tableCell.isUserInteractionEnabled = false
        tableCell.accessoryType = .none
    }
    
    static func stylePainscaleButton(_ button: UIButton, range: Int){
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = UIFont(name: "Futura", size: 18)
        print("here")
        switch range {
        case 1:
            button.layer.borderColor = hexToCGColor(hex: "#10b5d6ff")
            button.setTitleColor(UIColor.init(hex: "#10b5d6ff"), for: .normal)
        case 2:
            button.layer.borderColor = hexToCGColor(hex: "#4fba82ff")
            button.setTitleColor(UIColor.init(hex: "#4fba82ff"), for: .normal)
        case 3:
            button.layer.borderColor = hexToCGColor(hex: "#ffcd2bff")
            button.setTitleColor(UIColor.init(hex: "#ffcd2bff"), for: .normal)
        case 4:
            button.layer.borderColor = hexToCGColor(hex: "#f68837ff")
            button.setTitleColor(UIColor.init(hex: "#f68837ff"), for: .normal)
        case 5:
            button.layer.borderColor = hexToCGColor(hex: "#f05555ff")
            button.setTitleColor(UIColor.init(hex: "#f05555ff"), for: .normal)
        default:
            return
        }
    }
    
    static func styleFilledPainscaleButton(_ button: UIButton, range: Int){
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = UIFont(name: "Futura", size: 18)
        switch range {
        case 1:
            button.layer.borderColor = hexToCGColor(hex: noPainColorCode)
            button.backgroundColor = UIColor(hex: noPainColorCode)
            button.setTitleColor(UIColor.black, for: .normal)
        case 2:
            button.layer.borderColor = hexToCGColor(hex: mildPainColorCode)
            button.backgroundColor = UIColor(hex: mildPainColorCode)
            button.setTitleColor(UIColor.black, for: .normal)
        case 3:
            button.layer.borderColor = hexToCGColor(hex: moderatePainColorCode)
            button.backgroundColor = UIColor(hex: moderatePainColorCode)
            button.setTitleColor(UIColor.black, for: .normal)
        case 4:
            button.layer.borderColor = hexToCGColor(hex: severePainColorCode)
            button.backgroundColor = UIColor(hex: severePainColorCode)
            button.setTitleColor(UIColor.black, for: .normal)
        case 5:
            button.layer.borderColor = hexToCGColor(hex: maxPainColorCode)
            button.backgroundColor = UIColor(hex: maxPainColorCode)
            button.setTitleColor(UIColor.black, for: .normal)
        default:
            return
        }
    }
    
    static func styleView(_ view: UIView){
        view.backgroundColor = UIColor.init(hex: backgroundColor)
    }
}
