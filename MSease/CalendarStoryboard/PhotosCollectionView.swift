//
//  PhotosCollectionView.swift
//  MSease
//
//  Created by Negar on 2021-02-15.
//

import UIKit

// MARK: - Cell
class photoCollectionViewCell: UICollectionViewCell, CollectionCellAutoLayout {
    var cachedSize: CGSize?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return preferredLayoutAttributes(layoutAttributes)
    }
}

// MARK: - CollectionView
//class PhotosCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//
////    let PhotosCollectionViewCell = "imageCollectionCell"
////    let sectionInsets = UIEdgeInsets(top: 5.0, left: 4.0, bottom: 5.0, right: 4.0)
//
//    var cgsize : CGSize? = nil
//    var note : Note?
//    var isNewNote = true
//
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//        self.delegate = self
//        self.dataSource = self
//    }
    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if isNewNote{
//            return 1
//        }
//        else{
//            return (note?.images.count)!
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell, for: indexPath) as! photoCollectionViewCell
//        cell.imageView.image = UIImage(systemName: "camera.fill")
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0{
//            let notesVC = parent
//            let picker = UIImagePickerController()
//            picker.sourceType = .camera
//            picker.delegate = self
//            present(picker, animated: true)
//            
//        }
//    }

//}

//extension PhotosCollectionView: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow: CGFloat = 4
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + sectionInsets.right * (itemsPerRow + 1)
//        let availableWidth = self.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        cgsize=CGSize(width: widthPerItem, height: widthPerItem)
//        return cgsize!
//    }
//}
