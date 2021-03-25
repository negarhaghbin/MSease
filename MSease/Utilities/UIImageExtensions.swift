//
//  UIImageExtensions.swift
//  MSease
//
//  Created by Negar on 2021-03-25.
//

import Foundation
import UIKit

extension UIImage{
    func scaleTo(newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
