//
//  SymptomsCollectionViewCell.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import UIKit

class SymptomsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    func initiate(){
        self.name.adjustsFontSizeToFitWidth = true
        self.name.minimumScaleFactor = 0.5
    }
    
    func add(to symptoms: [String])->[String]{
        var result = symptoms
        self.checkmarkImage.isHidden = false
        result.append(self.name.text!)
        return result
    }
    
    func remove(from symptoms: [String])->[String]{
        var result = symptoms
        self.checkmarkImage.isHidden = true
        let index = result.lastIndex(of: self.name.text!)
        result.remove(at: index!)
        return result
    }
    
}
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader, for: indexPath) as? SymptomsCollectionReusableView{
                sectionHeader.sectionHeaderlabel.text = SymptomCollectionHeader[indexPath.section]
                return sectionHeader
            }
            return UICollectionReusableView()
    }*/
