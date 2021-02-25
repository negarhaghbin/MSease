//
//  SymptomsCollectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import UIKit
import RealmSwift

private let SymptomsViewCellIdentifier = "symptomCollectionCell"
private let sectionHeader = "symptomCollectionSectionHeader"

// MARK: - Symptom Cells

class SymptomsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var symptomImage: UIImageView!
    @IBOutlet weak var symptomName: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    func initiate(){
        self.symptomName.adjustsFontSizeToFitWidth = true
        self.symptomName.minimumScaleFactor = 0.5
    }
    
}

// MARK: - Collection ViewController
class SymptomsCollectionViewController: UIViewController{

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 3.0, bottom: 5.0, right: 4.0)
    let SymptomCollectionHeader : [String] = ["Symptom"]
    let symptoms = RealmManager.shared.getSymptoms()
    
    var cgsize : CGSize? = nil
    var selectedSymptoms : [Symptom] = []
    
    var note : Note?{
        didSet {
            refreshUI()
        }
    }
    var isNewNote = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = note?.date
        mainCollectionView.reloadData()
//        print(selectedSymptoms)
    }
    
    func refreshUI(){
        selectedSymptoms = note!.getSymptoms()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextSymptomPage" {
            let vc = segue.destination as? AdditionalSymptomInfoTableViewController
            vc!.selectedSymptoms = selectedSymptoms
            vc!.note = note
//            vc!.date = date
            vc!.isNewNote = isNewNote
        }
    }

}

// MARK: - Collection View Delegate and Data Source
extension SymptomsCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymptomsViewCellIdentifier, for: indexPath) as! SymptomsCollectionViewCell
        cell.symptomImage.image = UIImage(named: symptoms[indexPath.row].imageName)
        cell.symptomName.text = symptoms[indexPath.row].name
        if selectedSymptoms.contains(symptoms[indexPath.row]){
            cell.checkmarkImage.isHidden = false
        }
        else{
            cell.checkmarkImage.isHidden = true
        }
        return cell
    }
    
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SymptomCollectionHeader.count
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symptoms.count
    }
    
    

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
            if cell.checkmarkImage.isHidden{
                cell.checkmarkImage.isHidden = false
                selectedSymptoms.append(symptoms[indexPath.row])
//                print(selectedSymptoms)
            }
            else{
                cell.checkmarkImage.isHidden = true
                let index = selectedSymptoms.lastIndex(of: symptoms[indexPath.row])
                selectedSymptoms.remove(at: index!)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader, for: indexPath) as? SymptomsCollectionReusableView{
                sectionHeader.sectionHeaderlabel.text = SymptomCollectionHeader[indexPath.section]
                return sectionHeader
            }
            return UICollectionReusableView()
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
}

// MARK: - Collection View Flow Layout
extension SymptomsCollectionViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = round(view.frame.width/150.0)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        cgsize=CGSize(width: widthPerItem, height: widthPerItem)
    return cgsize!
  }
}
