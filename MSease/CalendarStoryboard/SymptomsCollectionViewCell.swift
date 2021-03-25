//
//  SymptomsCollectionViewCell.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import UIKit

class SymptomsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var symptomImage: UIImageView!
    @IBOutlet weak var symptomName: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    func initiate(){
        self.symptomName.adjustsFontSizeToFitWidth = true
        self.symptomName.minimumScaleFactor = 0.5
    }
    
    func addSymptom(){
        self.checkmarkImage.isHidden = false
        selectedSymptomNames.append(self.symptomName.text!)
    }
    
    func removeSymptom(){
        self.checkmarkImage.isHidden = true
        let index = selectedSymptomNames.lastIndex(of: self.symptomName.text!)
        selectedSymptomNames.remove(at: index!)
    }
    
}
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader, for: indexPath) as? SymptomsCollectionReusableView{
                sectionHeader.sectionHeaderlabel.text = SymptomCollectionHeader[indexPath.section]
                return sectionHeader
            }
            return UICollectionReusableView()
    }*/
