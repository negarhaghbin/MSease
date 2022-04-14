//
//  SymptomsCollectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import UIKit
import RealmSwift

var selectedSymptomNames: [String] = []
var selectedImages: [String] = []

class SymptomsCollectionViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var symptomsCollectionView: UICollectionView!
    
    // MARK: - Variables
    enum Cellid: String {
        case PhotosCollection = "imageCollectionCell"
        case SymptomsCollection = "symptomCollectionCell"
    }
    
    enum Sections: Int {
        case symptoms = 0
        case time
        case note
        case photo
    }
    
    var note: Note? {
        didSet {
            refreshUI()
        }
    }

    var isNewNote: Bool?
    
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
        
        if let note = note {
            textView.text = note.textContent
            timeLabel.text = convertToAMPM(oldTime: note.time)
            
            let time = getTimeFromTimeInDayString(note.time)
            var date = getDateFromString(note.date)
            if let calendarDate = Calendar.current.date(bySettingHour: time.h, minute: time.m, second: 0, of: date) {
                date = calendarDate
                timePicker.date = date
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        symptomsCollectionView.reloadData()
        photoCollectionView.reloadData()
    }
    
    // MARK: - UIDatePickerView
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        timeLabel.text = sender.date.getTime()
    }
    
    // MARK: - Note Text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isNewNote == true {
            textView.text = ""
        }
        textView.textColor = UIColor.label
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let content = (textView.text == "Add a note..." ? "" : textView.text)!
        
        let note = Note(textContent: content, date: timePicker.date, imageURLs: selectedImages, symptoms: selectedSymptomNames, partition: RealmManager.shared.getPartitionValue(), hasBucket: false)
        
        note._id = self.note!._id
        (isNewNote == true) ? RealmManager.shared.addNote(newNote: note) : RealmManager.shared.editNote(newNote: note)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if isNewNote == true {
            app.currentUser?.functions.deleteNoteBucket([AnyBSON(note!._id.stringValue)]) { (_) in
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 1) {
            timePicker.isHidden = !timePicker.isHidden
            AnimateTableCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: Sections.symptoms.rawValue) {
            return CGFloat(150.0)
        } else if indexPath == IndexPath(row: 1, section: Sections.time.rawValue) {
            return timePicker.isHidden ? 0.0 : 200.0
        } else if indexPath == IndexPath(row: 0, section: Sections.note.rawValue) {
            return CGFloat(170.0)
        } else if indexPath == IndexPath(row: 0, section: Sections.photo.rawValue) {
            return CGFloat(120.0)
        }
        return CGFloat(46.0)
    }
    
    // MARK: - Helpers
    
    func refreshUI() {
        guard let note = note else { return }
        
        title = note.date
        selectedSymptomNames = note.getSymptoms()
        selectedImages = note.getImageNames()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

// MARK: - UICollectionViewDelegate
extension SymptomsCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoCollectionView {
            return selectedImages.count + 1
        } else if collectionView == symptomsCollectionView {
            return symptoms.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photoCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cellid.PhotosCollection.rawValue, for: indexPath) as? photoCollectionViewCell else { return UICollectionViewCell() }
            
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(systemName: "camera.fill")
            } else {
                let imageThubmNail = RealmManager.shared.getImageThumbnail(id: selectedImages[indexPath.row - 1])
                cell.imageView.image = imageThubmNail
            }
            
            return cell
        } else if collectionView == symptomsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cellid.SymptomsCollection.rawValue, for: indexPath) as? SymptomsCollectionViewCell else { return UICollectionViewCell() }
            
            cell.tag = indexPath.row
            cell.initiate(symptom: symptoms[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == photoCollectionView {
            if indexPath.row == 0 {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self

                var alert = UIAlertController(title: nil, message: "Choose a source", preferredStyle: .actionSheet)
                
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    alert = UIAlertController(title: nil, message: "Choose a source", preferredStyle: .alert)
                }

                alert.addAction(UIAlertAction(title: "Camera", style: .default) { (result : UIAlertAction) -> Void in
                    picker.sourceType = .camera
                    self.present(picker, animated: true)
                  })
                alert.addAction(UIAlertAction(title: "Photo library", style: .default) { (result : UIAlertAction) -> Void in
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true)
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (result : UIAlertAction) -> Void in
                    alert.dismiss(animated: true)
                })
                present(alert, animated: true)
            } else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Symptom", bundle: nil)
                if let vc = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageVC") as? FullscreenImageViewController {
                    vc.imageInfo = (imageName: selectedImages[indexPath.row-1], bucketName: note!._id.stringValue)
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if collectionView == symptomsCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
                if cell.checkmarkImage.isHidden{
                    selectedSymptomNames = cell.add(to: selectedSymptomNames)
                } else {
                    selectedSymptomNames = cell.remove(from: selectedSymptomNames)
                }
            }
        }
    }
}

// MARK: - Image Picker Delegate
extension SymptomsCollectionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage{
            let imageObject = Image(image: (originalImage.jpegData(compressionQuality: 1.0))!, thumbNail: (originalImage.jpegData(compressionQuality: 0.1))!, referencingNoteID: (note!._id))
            
            RealmManager.shared.addImage(newImage: imageObject)
            selectedImages.append(imageObject._id.stringValue)
        }
        
        picker.dismiss(animated: true , completion: {
            self.photoCollectionView.reloadData()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

