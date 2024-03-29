//
//  StylingUtilities.swift
//  MSease
//
//  Created by Negar on 2021-03-15.
//

import Foundation
import UIKit

class StylingUtilities{
    static let backgroundColor = "#F8F8F8FF"
    static let circleColor = "#D88C84FF"
    static let buttonColor = UIColor(hex: "#749E98FF")
    static let borderColor = "#687794FF"
    
    enum PainColorCode : String{
        case nopain = "#10b5d6ff"
        case mild = "#4fba82ff"
        case moderate = "#ffcd2bff"
        case severe = "#f68837ff"
        case max = "#f05555ff"
    }
    
    static let InjectionCodes : [(colorCode: String, daysPassed: Int)] = [("#d9514cff", daysPassed: 0), ("#F07470dd", daysPassed: 1), ("#F1959Bcc", daysPassed: 2), ("#98d698cc", daysPassed: 3), ("#7bbd7bdd", daysPassed: 4), ("#7ea884ff", daysPassed: 5)]
    
    static func styleQuestionnaireView(_ view: UIView){
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(hex: StylingUtilities.borderColor)?.cgColor
    }
    
    static func styleTextFieldView(_ view: UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    static func styleFilledButton(_ button: UIButton){
        button.backgroundColor = buttonColor
        if !button.isEnabled{
            button.backgroundColor = UIColor.gray
        }
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Futura", size: 17)
    }
    
    static func styleHollowdButton(_ button: UIButton){
        button.backgroundColor = UIColor(hex: StylingUtilities.backgroundColor)
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
        button.backgroundColor = UIColor.systemBackground
        switch range {
        case 1:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.nopain.rawValue)
            button.setTitleColor(UIColor.init(hex: PainColorCode.nopain.rawValue), for: .normal)
        case 2:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.mild.rawValue)
            button.setTitleColor(UIColor.init(hex: PainColorCode.mild.rawValue), for: .normal)
        case 3:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.moderate.rawValue)
            button.setTitleColor(UIColor.init(hex: PainColorCode.moderate.rawValue), for: .normal)
        case 4:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.severe.rawValue)
            button.setTitleColor(UIColor.init(hex: PainColorCode.severe.rawValue), for: .normal)
        case 5:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.max.rawValue)
            button.setTitleColor(UIColor.init(hex: PainColorCode.max.rawValue), for: .normal)
        default:
            return
        }
    }
    
    static func styleFilledPainscaleButton(_ button: UIButton, range: Int){
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = UIFont(name: "Futura", size: 18)
        button.setTitleColor(UIColor.black, for: .normal)
        switch range {
        case 1:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.nopain.rawValue)
            button.backgroundColor = UIColor(hex: PainColorCode.nopain.rawValue)
            
        case 2:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.mild.rawValue)
            button.backgroundColor = UIColor(hex: PainColorCode.mild.rawValue)
        case 3:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.moderate.rawValue)
            button.backgroundColor = UIColor(hex: PainColorCode.moderate.rawValue)
        case 4:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.severe.rawValue)
            button.backgroundColor = UIColor(hex: PainColorCode.severe.rawValue)
        case 5:
            button.layer.borderColor = hexToCGColor(hex: PainColorCode.max.rawValue)
            button.backgroundColor = UIColor(hex: PainColorCode.max.rawValue)
        default:
            return
        }
    }
    
    static func styleView(_ view: UIView){
        view.backgroundColor = UIColor(hex: StylingUtilities.backgroundColor)
    }
}
