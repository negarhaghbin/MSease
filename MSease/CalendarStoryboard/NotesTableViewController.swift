//
//  NotesTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-14.
//

import UIKit

class NotesTableViewController: UIViewController {
    
    let cellIdentifier = "notesTableViewCell"
    var date : Date?
    var notes : [Note] = []
    
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var symptomsView : UIView!
    @IBOutlet weak var shadowView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        titleDateLabel.text = date?.getUSFormat()
//        date?.printFullTime()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationItem.title = "Cancel"
//        print(self.navigationController?.navigationItem.title)
        self.title = date?.getUSFormat()
        notes = RealmManager.shared.getNotes(for: date!)
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
            cell.contentLabel.text = notes[indexPath.row].textContent
            cell.timeLabel.text = notes[indexPath.row].time
            
//            let exercise = sections[indexPath.section-1].exercises[indexPath.row]
//            cell.titleLabel.text = exercise.exercise?.name
//            cell.previewImageView.image = UIImage(named: (exercise.gifName + ".gif"))
        }
        return cell
    }
    
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
//            let selectedExercise = sections[indexPath.section-1].exercises[indexPath.row]
//            delegate?.exerciseSelected(selectedExercise)
        }
        
    }
    
    
}
