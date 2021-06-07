//
//  SymptomsPopupViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import UIKit

class SymptomsPopupViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Variables
    enum segueIds : String {
        case showAddSymptoms
        case addInjection
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func closePopup(_ sender: Any) {
        dismissPopup()
    }
    
    @IBAction func addInjectionTapped(_ sender: Any) {
        dismissPopup()
        let storyboard = UIStoryboard(name: "Symptom", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editInjection") as! InjectionTableViewController
        vc.isNewInjection = true
        if let notesVC = parent as? NotesTableViewController{
            vc.date = notesVC.date
        }
        else if let parentVC = parent as? MainViewController{
            vc.date = parentVC.selectedDate
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper
    func dismissPopup(){
        if let parentVC = parent as? NotesTableViewController{
            parentVC.symptomsView.animHide()
            parentVC.shadowView.isHidden = true
        }
        else if let parentVC = parent as? MainViewController{
            parentVC.symptomsView.animHide()
            parentVC.shadowView.isHidden = true
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dismissPopup()
        var date : Date?
        if let notesVC = parent as? NotesTableViewController{
           date = notesVC.date
        }
        else if let parentVC = parent as? MainViewController{
            date = parentVC.selectedDate
        }
        
        if let symptomsVC = segue.destination as? SymptomsCollectionViewController{
            symptomsVC.isNewNote = true
            symptomsVC.note = Note(textContent: "Add a note...", date: date, imageURLs: [], symptoms: [], partition: RealmManager.shared.getPartitionValue())
        }
        
    }
    

}
