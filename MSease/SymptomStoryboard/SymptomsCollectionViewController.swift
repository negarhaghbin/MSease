//
//  SymptomsCollectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import UIKit

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
    
    enum sections : Int{
        case symptoms = 0
        case time
        case note
        case photo
    }
    
    var note : Note?{
        didSet{
            refreshUI()
        }
    }

    var selectedImages : [String] = [] // names, TODO: fill it in view will appear. (starts with an empty array)
    var isNewNote : Bool?
    
//    lazy var partitionValue = RealmManager.shared.getPartitionValue()
    
    // MARK: - View Controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        textView.inputAccessoryView = toolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeLabel.text = convertToAMPM(oldTime: note!.time)
        
        let time = getTimeFromTimeInDayString(note!.time)
        var date = getDateFromString(note!.date)
        date = date.setTime(h: time.h, m: time.m)
        timePicker.date = date
        
        textView.text = note?.textContent
        symptomsCollectionView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        photoCollectionView.reloadData()
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
        textView.textColor = UIColor.label
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let content = (textView.text == "Add a note..." ? "" : textView.text)!
        print("selected Images:\(selectedImages)")
        let note = Note(textContent: content, date: timePicker.date, imageURLs: selectedImages, symptoms: selectedSymptomNames, partition: RealmManager.shared.getPartitionValue())
        
        if isNewNote!{
            RealmManager.shared.addNote(newNote: note)
        }
        else{
            note._id = self.note!._id
            RealmManager.shared.editNote(newNote: note)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath(row: 0, section: 1){
            timePicker.isHidden = !timePicker.isHidden
            AnimateTableCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: sections.symptoms.rawValue) {
            return CGFloat(150.0)
        }
        else if indexPath == IndexPath(row: 1, section: sections.time.rawValue) {
            let height:CGFloat = timePicker.isHidden ? 0.0 : 200.0
            return height
        }
        else if indexPath == IndexPath(row: 0, section: sections.note.rawValue) {
            return CGFloat(170.0)
        }
        else if indexPath == IndexPath(row: 0, section: sections.photo.rawValue) {
            return CGFloat(120.0)
        }
        return CGFloat(46.0)
    }
    
    // MARK: - Helpers
    func refreshUI(){
        self.title = note!.date
        selectedSymptomNames = note!.getSymptoms()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

// MARK: - UICollectionViewDelegate
extension SymptomsCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.photoCollectionView{
//            print(selectedImages.count)
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
                print("photo")
                let imageThubmNail = RealmManager.shared.getImageThumbnail(id: selectedImages[indexPath.row-1])
//                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                cell.imageView.image = imageThubmNail
            }
            return cell
        }
        else if collectionView == self.symptomsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid.SymptomsCollection.rawValue, for: indexPath) as! SymptomsCollectionViewCell
            cell.tag = indexPath.row
            cell.initiate(symptom: symptoms[indexPath.row])
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
                vc.imageName = selectedImages[indexPath.row-1]
                vc.selectedImages = selectedImages
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if collectionView == self.symptomsCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
                if cell.checkmarkImage.isHidden{
                    selectedSymptomNames = cell.add(to: selectedSymptomNames)
                }
                else{
                    selectedSymptomNames = cell.remove(from: selectedSymptomNames)
                }
            }
        }
    }
}

// MARK: - Image Picker Delegate
extension SymptomsCollectionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let editedImage = info[.editedImage] as? UIImage{
//            selectedImageFromPicker = editedImage
//        }
//        else
        if let originalImage = info[.originalImage] as? UIImage{
            print((originalImage.jpegData(compressionQuality: 1.0))!)
            
            let imageObject = Image(image: (originalImage.jpegData(compressionQuality: 1.0))!, thumbNail: (originalImage.jpegData(compressionQuality: 0.1))!)
            
            RealmManager.shared.addImage(newImage: imageObject)
            selectedImages.append(imageObject._id.stringValue)
        }
        
        
        
//        if let selectedImage = selectedImageFromPicker{
//            selectedImages.append("\(selectedImage.)")
//        }
//        if let image = info[.imageURL] as? NSURL{
//            print("image: \(image)")
        
//        }
        picker.dismiss(animated: true , completion: {
            self.photoCollectionView.reloadData()
//            self.tableView.reloadSections([sections.photo.rawValue], with: .automatic)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

