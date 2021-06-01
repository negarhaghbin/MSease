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
    enum cellIdentifier: String{
        case notesTableViewCell
        case injectionsTableViewCell
        case healthTableCell
    }
    
    var date : Date?{
        didSet{
            initSetup()
        }
    }
    
//    lazy var partitionValue = RealmManager.shared.getPartitionValue()
    
    var notificationToken: NotificationToken?
    var injectionNotificationToken: NotificationToken?
    var notes: Results<Note>?
    var injections: Results<Injection>?
    var selectedRow = 0
    
    enum sections: Int, CaseIterable {
        case addNew = 0
        case health
        case injections
        case notes
    }
    

    deinit {
        notificationToken?.invalidate()
        injectionNotificationToken?.invalidate()
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var symptomsView : UIView!
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: sections.health.rawValue)], with: .automatic)
    }
    
    // MARK: - Helpers
    
    func updateTable<T: Object>(changes: RealmCollectionChange<Results<T>>,section: Int){
        guard let tableView = self.tableView else { return }
        switch changes {
        case .initial:
            tableView.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
            tableView.performBatchUpdates({
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: section) }),
                    with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: section) }),
                    with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: section) }),
                    with: .automatic)
            })
            tableView.reloadData()
        case .error(let error):
            fatalError("\(error)")
        }
    }
    
    func initSetup() {
        self.title = date!.getUSFormat()
        notes = RealmManager.shared.getNotes(for: date!)
        injections = RealmManager.shared.getInjections(for: date!)
        
        notificationToken = notes!.observe { [weak self] (changes) in
            self!.updateTable(changes: changes, section: sections.notes.rawValue)
        }
        
        injectionNotificationToken = injections?.observe{ [weak self] (changes) in
            self!.updateTable(changes: changes, section: sections.injections.rawValue)
        }
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let vc = segue.destination as? SymptomsCollectionViewController
//            vc!.partitionValue = RealmManager.shared.getPartitionValue()
            vc!.note = notes![selectedRow]
            vc!.selectedImages = notes![selectedRow].getImages()
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
        if indexPath.section == sections.injections.rawValue{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.injectionsTableViewCell.rawValue, for: indexPath) as! InjectionTableViewCell
            cell.tag = indexPath.row
            cell.initiate(injections: injections!)
            
            return cell
        }
        else if indexPath.section == sections.health.rawValue{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.healthTableCell.rawValue, for: indexPath) as! HealthTableViewCell
            cell.tag = indexPath.row
            
            cell.initiate(count: RealmManager.shared.getSteps(date: date!)?.count ?? -1)
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.notesTableViewCell.rawValue, for: indexPath) as! NotesTableViewCell
            if indexPath.section == sections.addNew.rawValue{
                cell.setup(isNoteInstance: false)
            }
            else if indexPath.section == sections.notes.rawValue{
                cell.setup(isNoteInstance: true)
                    
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionView(sender:)))
                cell.collectionView.isUserInteractionEnabled = true
                cell.collectionView.addGestureRecognizer(tapGestureRecognizer)
                    
                cell.contentLabel.text = notes![indexPath.row].textContent
                cell.timeLabel.text = convertToAMPM(oldTime: notes![indexPath.row].time)
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sections.injections.rawValue{
            return CGFloat(80)
        }
        if indexPath.section == sections.notes.rawValue{
            return CGFloat(150)
        }
        return CGFloat(100)
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
//            vc.partitionValue = RealmManager.shared.getPartitionValue()
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
