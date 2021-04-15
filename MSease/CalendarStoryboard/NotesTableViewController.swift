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
    
    var partitionValue = RealmManager.shared.getPartitionValue()
    
    var notificationToken: NotificationToken?
    var injectionNotificationToken: NotificationToken?
    var notes: Results<Note>?
    var injections: Results<Injection>?
    var selectedRow = 0
    
    enum sections: Int, CaseIterable {
        case addNew = 0
        case injections
        case notes
    }

    deinit {
        notificationToken?.invalidate()
        injectionNotificationToken?.invalidate()
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
        notes = RealmManager.shared.getNotes(for: date!)
        injections = RealmManager.shared.getInjections(for: date!)

        notificationToken = notes!.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: sections.notes.rawValue) }),
                        with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: sections.notes.rawValue) }),
                        with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: sections.notes.rawValue) }),
                        with: .automatic)
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        injectionNotificationToken = injections?.observe{ [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: sections.injections.rawValue) }),
                        with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: sections.injections.rawValue) }),
                        with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: sections.injections.rawValue) }),
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
            vc!.partitionValue = partitionValue
            vc!.note = notes![selectedRow]
            vc!.isNewNote = false
            
        }
        /*else if segue.identifier == "editInjection" {
            let vc = segue.destination as? InjectionTableViewController
            vc!.partitionValue = partitionValue
            vc!.injection = injections![selectedRow]
            vc!.isNewInjection = false
        }*/
    }
    

}

// MARK: - UITableViewController
extension NotesTableViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sections.injections.rawValue{
            return injections!.count
        }
        if section == sections.notes.rawValue{
            return notes!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sections.injections.rawValue{
           return "Injections"
        }
        if section == sections.notes.rawValue{
           return "Notes"
        }
        else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == sections.injections.rawValue{
            if injections?.count == 0{
                return "You have no injections on this day."
            }
        }
        if section == sections.notes.rawValue{
            if notes?.count == 0{
                return "You have no notes on this day."
            }
        }
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotesTableViewCell
            else{
                return NotesTableViewCell()
        }
        
        if indexPath.section == sections.addNew.rawValue{
            cell.setup(isNoteInstance: false)
            
        }
        else {
            cell.setup(isNoteInstance: true)
             let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionView(sender:)))
            cell.collectionView.isUserInteractionEnabled = true
            cell.collectionView.addGestureRecognizer(tapGestureRecognizer)
            
            if indexPath.section == sections.injections.rawValue{
                cell.contentLabel.text = injections![indexPath.row].limbName
                cell.timeLabel.text = injections![indexPath.row].time
                cell.collectionView.isHidden = true
//                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            }
            else if indexPath.section == sections.notes.rawValue{
                cell.contentLabel.text = notes![indexPath.row].textContent
                cell.timeLabel.text = notes![indexPath.row].time
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            }
            
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotesTableViewCell
//        cell!.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sections.injections.rawValue{
            return CGFloat(90)
        }
        if indexPath.section == sections.notes.rawValue{
            return CGFloat(150)
        }
        return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == sections.addNew.rawValue{
            shadowView.isHidden = false
            symptomsView.animShow()
        }
        else if indexPath.section == sections.notes.rawValue{
            selectedRow = indexPath.row
            performSegue(withIdentifier: "editNote", sender: nil)
        }
        else if indexPath.section == sections.injections.rawValue{
            selectedRow = indexPath.row
            
            let storyboard = UIStoryboard(name: "Symptom", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "editInjection") as! InjectionTableViewController
            vc.title = "Edit injection"
            vc.partitionValue = partitionValue
            vc.injection = injections![selectedRow]
            vc.isNewInjection = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == sections.injections.rawValue{
                RealmManager.shared.removeInjection(injection: injections![indexPath.row])
            }
            else if indexPath.section == sections.notes.rawValue{
                RealmManager.shared.removeNote(note: notes![indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == sections.addNew.rawValue{
            return false
        }
        else{
            return true
        }
    }
    
    
}


// MARK: Collection View

// FIXME: - baraye injections dorostesh kon
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
