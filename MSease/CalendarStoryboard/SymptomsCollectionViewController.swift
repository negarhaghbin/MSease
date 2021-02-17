//
//  SymptomsCollectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import UIKit
import RealmSwift

private let SymptomsViewCellIdentifier = "symptomCollectionCell"
private let NotesViewCellIdentifier = "noteCollectionCell"
private let NotePhotoViewCellIdentifier = "notePhotoCollectionCell"
private let sectionHeader = "symptomCollectionSectionHeader"

class SymptomsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var symptomImage: UIImageView!
    @IBOutlet weak var symptomName: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    func initiate(){
        self.symptomName.adjustsFontSizeToFitWidth = true
        self.symptomName.minimumScaleFactor = 0.5
    }
    
}

class NotesCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var noteTextView: NoteTextView!
    
}

class NoteTextView : UITextView, UITextViewDelegate{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor(named: "Label Color")
    }
}


class SymptomsCollectionViewController: UIViewController{

    @IBOutlet weak var buttonContainerView: UIView!
    var containerViewController: addSymptomContainerViewController?
    var date : Date? 
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    private var itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 3.0, bottom: 5.0, right: 4.0)

    var cgsize : CGSize? = nil
    var selectedSymptoms : [Symptom] = []
    
    let SymptomCollectionHeader : [String] = ["Symptom", "Note", "Photo"]
    
    enum Section : Int{
        case symptoms = 0
        case notes
        case photos
    }
    
    let symptoms = RealmManager.shared.getSymptoms()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = date?.getUSFormat()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSymptomButtonViewSegue" {
            containerViewController = segue.destination as? addSymptomContainerViewController
            containerViewController!.selectedSymptoms = selectedSymptoms
        }
    }

}

extension SymptomsCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Section.symptoms.rawValue{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymptomsViewCellIdentifier, for: indexPath) as! SymptomsCollectionViewCell
            cell.symptomImage.image = UIImage(named: symptoms[indexPath.row].imageName)
            cell.symptomName.text = symptoms[indexPath.row].name
            return cell
        }
        else if indexPath.section == Section.notes.rawValue{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesViewCellIdentifier, for: indexPath) as! NotesCollectionViewCell
            return cell
        }
        else if indexPath.section == Section.photos.rawValue{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotePhotoViewCellIdentifier, for: indexPath) as! NotePhotoCollectionViewCell
//            print(cell.photosCollectionView)
            return cell
        }
        return UICollectionViewCell()
    }
    
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SymptomCollectionHeader.count
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.symptoms.rawValue{
            return symptoms.count
        }
        else{
            return 1
        }
        
    }
    
    

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
//            print(selectedSymptoms)
            if cell.checkmarkImage.isHidden{
                cell.checkmarkImage.isHidden = false
                selectedSymptoms.append(symptoms[indexPath.row])
            }
            else{
                cell.checkmarkImage.isHidden = true
                let index = selectedSymptoms.lastIndex(of: symptoms[indexPath.row])
                selectedSymptoms.remove(at: index!)
            }
            
            if selectedSymptoms.count != 0{
                buttonContainerView.isHidden = false
            }
            else{
                buttonContainerView.isHidden = true
            }
        }
//        else if let cell = collectionView.cellForItem(at: indexPath) as? NotesCollectionViewCell{
//            print("tapped")
//            cell.noteTextView.text = ""
//        }
       
        
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

extension SymptomsCollectionViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == Section.symptoms.rawValue{
        itemsPerRow = round(view.frame.width/150.0)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        cgsize=CGSize(width: widthPerItem, height: widthPerItem)
    }
    else if indexPath.section == Section.notes.rawValue{
        itemsPerRow = 1
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        cgsize=CGSize(width: widthPerItem, height: CGFloat(100))
    }
    else if indexPath.section == Section.photos.rawValue{
        itemsPerRow = 1
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        cgsize=CGSize(width: widthPerItem, height: CGFloat(50))
    }
    
    return cgsize!
  }
}

extension SymptomsCollectionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
//            note.addimage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
