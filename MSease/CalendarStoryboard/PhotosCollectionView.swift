//
//  PhotosCollectionView.swift
//  MSease
//
//  Created by Negar on 2021-02-15.
//

import UIKit

class PhotosCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let PhotosCollectionViewCell = "imageCollectionCell"
    
    private var rows: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 3.0, bottom: 5.0, right: 4.0)

    var cgsize : CGSize? = nil
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell, for: indexPath) as! photoCollectionViewCell
        if indexPath.row == 0{
            cell.imageView.image = UIImage(systemName: "camera.fill")
        }
        return cell
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension PhotosCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.top * (rows + 1) + sectionInsets.bottom * (rows + 1)
        let availableHeight = self.frame.height - paddingSpace
        let heightPerItem = availableHeight / rows
        cgsize=CGSize(width: heightPerItem, height: heightPerItem)
        return cgsize!
    }
}
