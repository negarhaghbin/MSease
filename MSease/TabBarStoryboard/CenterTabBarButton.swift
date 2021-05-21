//
//  CenterTabBarButton.swift
//  MSease
//
//  Created by Negar on 2021-05-07.
//

import UIKit

class CenterTabBarButton: UITabBar {

    var prominentButtonCallback: (()->())?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let items = items, items.count>0 else {
            return super.hitTest(point, with: event)
        }
        
        let middleWidth:CGFloat = 75.0
//            bounds.width/CGFloat(items.count)
        let middleRect = CGRect(x: middleWidth * 2.0, y: -middleWidth/2, width: middleWidth, height: middleWidth)
        if !isHidden && middleRect.contains(point) {
            prominentButtonCallback?()
            return nil
        }
        return super.hitTest(point, with: event)
    }
}
