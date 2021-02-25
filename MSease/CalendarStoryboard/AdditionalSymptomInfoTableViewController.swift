//
//  AdditionalSymptomInfoTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import UIKit

class AdditionalSymptomInfoTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let PhotosCollectionViewCell = "imageCollectionCell"
    
    var note : Note?
    var selectedSymptoms : [Symptom] = []
    var selectedImages : [String] = [] // names, TODO: fill it in picking images
    var isNewNote : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        timePicker.date = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = note?.date
        timeLabel.text = note!.time
        
        let time = getTimeFromString(note!.time)
        var date = getDateFromString(note!.date)
        date = date.setTime(h: time.h, m: time.m)
        timePicker.date = date
        
        textView.text = note?.textContent
        selectedImages = Array(note!.images)
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
    
    // MARK: - Action
    @IBAction func saveButtonTapped(_ sender: Any) {
        print(selectedSymptoms)
        let note = Note(textContent: textView.text, date: timePicker.date, images: selectedImages, symptoms: selectedSymptoms)
        
        if isNewNote!{
            RealmManager.shared.addNote(newNote: note)
        }
        else{
            note._id = self.note!._id
            RealmManager.shared.editNote(newNote: note)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
        // TODO: go back to NotesTableViewController
        
        
    }
    
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath(row: 0, section: 0){
            timePicker.isHidden = !timePicker.isHidden
            AnimateTableCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 1, section: 0) {
            let height:CGFloat = timePicker.isHidden ? 0.0 : 200.0
            return height
        }
        else if indexPath == IndexPath(row: 0, section: 1) {
            return CGFloat(170.0)
        }
        else if indexPath == IndexPath(row: 0, section: 2) {
            return CGFloat(240.0)
        }
        return CGFloat(46.0)
    }
    
     
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

// MARK: - UICollectionViewDelegate
extension AdditionalSymptomInfoTableViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(selectedImages.count)
        return selectedImages.count+1
//        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell, for: indexPath) as! photoCollectionViewCell
        if indexPath.row == 0{
            cell.imageView.image = UIImage(systemName: "camera.fill")
        }
        else{
            print("photo")
            let url = URL(string: selectedImages[indexPath.row-1])
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.imageView.image = UIImage(data: data!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
}

// MARK: - Image Picker Delegate
extension AdditionalSymptomInfoTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.imageURL] as? NSURL{
            selectedImages.append("\(image)")
            collectionView.reloadData()
            tableView.reloadData()
        }
        print(selectedImages)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

