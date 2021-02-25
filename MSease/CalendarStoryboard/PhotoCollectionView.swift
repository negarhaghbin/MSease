//
//  PhotoCollectionView.swift
//  MSease
//
//  Created by Negar on 2021-02-24.
//

import UIKit

public protocol CollectionCellAutoLayout: class {
    var cachedSize: CGSize? { get set }
}

public extension CollectionCellAutoLayout where Self: UICollectionViewCell {
 
    func preferredLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        layoutAttributes.frame = newFrame
        cachedSize = newFrame.size
//        cachedSize = CGSize(width: 10, height: 10)
        return layoutAttributes
    }
}
