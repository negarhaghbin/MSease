//
//  SymptomsCollectionViewCell.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import UIKit

class SymptomsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    // MARK: - Helpers
    
    func initiate(symptom: Symptom) {
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.5
        
        image.image = UIImage(named: symptom.imageName)
        name.text = symptom.name
        checkmarkImage.isHidden = !selectedSymptomNames.contains(symptom.name)
    }
    
    func add(to symptoms: [String]) -> [String] {
        var result = symptoms
        checkmarkImage.isHidden = false
        result.append(name.text!)
        return result
    }
    
    func remove(from symptoms: [String]) -> [String] {
        var result = symptoms
        checkmarkImage.isHidden = true
        let index = result.lastIndex(of: name.text!)
        result.remove(at: index!)
        return result
    }
    
}
