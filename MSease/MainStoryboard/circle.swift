//
//  circle.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import UIKit

class circle: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let shadowOffset = CGSize(width: 3.1, height: 3.1)
        let shadowBlurRadius: CGFloat = 5
        
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        
        var path = UIBezierPath()
        path = UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: superview!.frame.width*0.9-20, height: superview!.frame.width*0.9-20))
        UIColor(hex: "#468FAFAA")!.setFill()
        UIColor.clear.setStroke()
        
        path.lineWidth = 5
        path.stroke()
        path.fill()
    }
}
