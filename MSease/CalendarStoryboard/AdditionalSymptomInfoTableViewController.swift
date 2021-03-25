//
//  SymptomsCollectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import UIKit
import RealmSwift
//import MSPeekCollectionViewDelegateImplementation

var selectedSymptomNames : [String] = []

class SymptomsCollectionViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var symptomsCollectionView: UICollectionView!
    
    // MARK: - Variables
    enum cellid : String{
        case PhotosCollection = "imageCollectionCell"
        case SymptomsCollection = "symptomCollectionCell"
    }
    
    var note : Note?{
        didSet{
            refreshUI()
        }
    }
//    var cgsize : CGSize? = nil

    var selectedImages : [String] = [] // names, TODO: fill it in picking images
    var isNewNote : Bool?
    
    var partitionValue: String?
    var realm: Realm?{
        didSet{
            initSetup()
        }
    }
    
    // MARK: - View Controllers
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeLabel.text = note!.time
        
        let time = getTimeFromString(note!.time)
        var date = getDateFromString(note!.date)
        date = date.setTime(h: time.h, m: time.m)
        timePicker.date = date
        
        textView.text = note?.textContent
        selectedImages = Array(note!.images)
        symptomsCollectionView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - UIDatePickerView
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        timeLabel.text = sender.date.getTime()
    }
    
    // MARK: - Note Text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isNewNote!{
            textView.text = ""
        }
        textView.textColor = UIColor(named: "Label Color")
    }
    
    // MARK: - Animation
    func AnimateTableCell(indexPath: IndexPath){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let content = (textView.text == "Add a note..." ? "" : textView.text)!
        let note = Note(textContent: content, date: timePicker.date, images: selectedImages, symptoms: selectedSymptomNames, partition: partitionValue!)
        
        if isNewNote!{
            RealmManager.shared.addNote(newNote: note, realm: realm!)
        }
        else{
            note._id = self.note!._id
            RealmManager.shared.editNote(newNote: note, realm: realm!)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
        // TODO: go back to NotesTableViewController
        
        
    }
    
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath(row: 0, section: 1){
            timePicker.isHidden = !timePicker.isHidden
            AnimateTableCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 0) {
            return CGFloat(122.0)
        }
        else if indexPath == IndexPath(row: 1, section: 1) {
            let height:CGFloat = timePicker.isHidden ? 0.0 : 200.0
            return height
        }
        else if indexPath == IndexPath(row: 0, section: 2) {
            return CGFloat(170.0)
        }
        else if indexPath == IndexPath(row: 0, section: 3) {
            return CGFloat(240.0)
        }
        return CGFloat(46.0)
    }
    
    // MARK: - Helpers
    func refreshUI(){
        self.title = note!.date
        selectedSymptomNames = note!.getSymptoms()
    }
    
    func initSetup() {
        guard let syncConfiguration = realm?.configuration.syncConfiguration else {
            fatalError("Sync configuration not found! Realm not opened with sync?")
        }
        partitionValue = syncConfiguration.partitionValue!.stringValue!
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

// MARK: - UICollectionViewDelegate
extension SymptomsCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.photoCollectionView{
            return selectedImages.count+1
        }
        else if collectionView == self.symptomsCollectionView{
            return symptoms.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.photoCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid.PhotosCollection.rawValue, for: indexPath) as! photoCollectionViewCell
            if indexPath.row == 0{
                cell.imageView.image = UIImage(systemName: "camera.fill")
            }
            else{
    //            print("photo")
                let url = URL(string: selectedImages[indexPath.row-1])
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                cell.imageView.image = UIImage(data: data!)
            }
            return cell
        }
        else if collectionView == self.symptomsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid.SymptomsCollection.rawValue, for: indexPath) as! SymptomsCollectionViewCell
            cell.symptomImage.image = UIImage(named: symptoms[indexPath.row].imageName)
            cell.symptomName.text = symptoms[indexPath.row].name
            if selectedSymptomNames.contains(symptoms[indexPath.row].name){
                cell.checkmarkImage.isHidden = false
            }
            else{
                cell.checkmarkImage.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.photoCollectionView{
            if indexPath.row == 0{
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self

                let alert = UIAlertController(title: nil, message: "Choose a source", preferredStyle: .actionSheet)

                alert.addAction(UIAlertAction(title: "Camera", style: .default) { (result : UIAlertAction) -> Void in
                    picker.sourceType = .camera
                    self.present(picker, animated: true)
                  })
                alert.addAction(UIAlertAction(title: "Photo library", style: .default) { (result : UIAlertAction) -> Void in
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true)
                })
                present(alert, animated: true)
            }
            else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Symptom", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageVC") as! FullscreenImageViewController
                vc.imageViewURL = URL(string: selectedImages[indexPath.row-1])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if collectionView == self.symptomsCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
                if cell.checkmarkImage.isHidden{
                    cell.addSymptom()
                }
                else{
                    cell.removeSymptom()
                }
            }
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SymptomsCollectionViewController : UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let leftSectionInset = CGFloat(2)
//          let itemsPerRow = round(view.frame.width/150.0)
//          let paddingSpace = 2 * leftSectionInset * (itemsPerRow + 1)
//          let availableWidth = view.frame.width - paddingSpace
//          let widthPerItem = availableWidth / itemsPerRow
//          cgsize=CGSize(width: widthPerItem, height: widthPerItem)
//      return cgsize!
//    }
}




// MARK: - Image Picker Delegate
extension SymptomsCollectionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.imageURL] as? NSURL{
            selectedImages.append("\(image)")
            photoCollectionView.reloadData()
            tableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

