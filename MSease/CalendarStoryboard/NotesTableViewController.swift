//
//  NotesTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-14.
//

import UIKit
import RealmSwift

class NotesTableViewController: UIViewController {
    
    // MARK: - Variables
    let cellIdentifier = "notesTableViewCell"
    var date : Date?{
        didSet{
            initSetup()
        }
    }
    
    var partitionValue: String?
    var realm: Realm?{
        didSet{
            guard let syncConfiguration = realm?.configuration.syncConfiguration else {
                fatalError("Sync configuration not found! Realm not opened with sync?")
            }
            partitionValue = syncConfiguration.partitionValue!.stringValue!
        }
    }
    var notificationToken: NotificationToken?
    var notes: Results<Note>?
    var selectedRow = 0

    deinit {
        notificationToken?.invalidate()
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var symptomsView : UIView!
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    func initSetup() {
        self.title = date!.getUSFormat()
        notes = RealmManager.shared.getNotes(for: date!, realm: realm!)

        notificationToken = notes!.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 1) }),
                        with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 1) }),
                        with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 1) }),
                        with: .automatic)
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let vc = segue.destination as? SymptomsCollectionViewController
            vc!.partitionValue = partitionValue!
            vc!.realm = realm
            vc!.note = notes![selectedRow]
            vc!.isNewNote = false
            
        }
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
            return notes!.count
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
            
            cell.contentLabel.text = notes![indexPath.row].textContent
            cell.timeLabel.text = notes![indexPath.row].time
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
            selectedRow = indexPath.row
            performSegue(withIdentifier: "editNote", sender: nil)
        }
    }
    
    
}

extension NotesTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes![collectionView.tag].symptomNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniSymptomsCell",
                                                      for: indexPath) as! MiniSymptomsCollectionViewCell

        cell.imageView.image = UIImage(named: Symptom.symptomImage(for: notes![collectionView.tag].symptomNames[indexPath.row]))
        
        return cell
    }
    
    @objc func didTapCollectionView(sender: UITapGestureRecognizer){
        selectedRow = sender.view!.tag
        performSegue(withIdentifier: "editNote", sender: nil)
    }
    
}
