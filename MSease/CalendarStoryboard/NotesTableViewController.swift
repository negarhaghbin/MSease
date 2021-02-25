//
//  NotesTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-14.
//

import UIKit

class NotesTableViewController: UIViewController {
    
    let cellIdentifier = "notesTableViewCell"
    var notes : [Note] = []
    var date : Date?{
        didSet{
            notes = RealmManager.shared.getNotes(for: date!)
        }
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var symptomsView : UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = date?.getUSFormat()
        tableView.reloadData()
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editSymptom" {
//            let symptomsVC = segue.destination as? SymptomsCollectionViewController
//            symptomsVC!.date = date
//        }
    }
    

}

// MARK: - UITableViewController
extension NotesTableViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return notes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        else{
           return "Previous Notes"
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotesTableViewCell
            else{
                return NotesTableViewCell()
        }
        
        if indexPath.section == 0{
            cell.setup(isNoteInstance: false)
            
        }
        else{
            cell.setup(isNoteInstance: true)
             let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionView(sender:)))
            cell.collectionView.isUserInteractionEnabled = true
            cell.collectionView.addGestureRecognizer(tapGestureRecognizer)
            
            cell.contentLabel.text = notes[indexPath.row].textContent
            cell.timeLabel.text = notes[indexPath.row].time
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotesTableViewCell
//        cell!.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(75)
        }
        else{
            return CGFloat(150)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            shadowView.isHidden = false
            symptomsView.animShow()
        }
        else if indexPath.section == 1{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Symptom", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SymptomCollectionVC") as! SymptomsCollectionViewController
            
            vc.note = notes[indexPath.row]
            
//            var dateComponents = Calendar.current.dateComponents([.hour,.minute], from: date!)
//            dateComponents.hour = Calendar.current.component(.hour, from: notes[indexPath.row].date)
//            dateComponents.minute = Calendar.current.component(.minute, from: notes[indexPath.row].date)
//
//            date = Calendar.current.date(from: dateComponents)
            
//            vc.date = notes[indexPath.row].date
            
            vc.isNewNote = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}

extension NotesTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes[collectionView.tag].symptoms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniSymptomsCell",
                                                      for: indexPath) as! MiniSymptomsCollectionViewCell

        cell.imageView.image = UIImage(named: notes[collectionView.tag].symptoms[indexPath.row].imageName)
        
        return cell
    }
    
    @objc func didTapCollectionView(sender: UITapGestureRecognizer){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Symptom", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SymptomCollectionVC") as! SymptomsCollectionViewController
        vc.note = notes[sender.view!.tag]
        vc.isNewNote = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
