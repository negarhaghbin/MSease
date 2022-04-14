//
//  photoCollectionViewCell.swift
//  MSease
//
//  Created by Negar on 2021-02-15.
//

import UIKit

class photoCollectionViewCell: UICollectionViewCell, CollectionCellAutoLayout {
    var cachedSize: CGSize?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return preferredLayoutAttributes(layoutAttributes)
    }
}
