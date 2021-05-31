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
        let notesVC = parent as! NotesTableViewController
//        vc.partitionValue = notesVC.partitionValue
        vc.isNewInjection = true
        vc.date = notesVC.date
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper
    func dismissPopup(){
        let notesVC = parent as! NotesTableViewController
        notesVC.symptomsView.animHide()
        notesVC.shadowView.isHidden = true
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        dismissPopup()
        let notesVC = parent as! NotesTableViewController
        
        if let symptomsVC = segue.destination as? SymptomsCollectionViewController{
//            symptomsVC.partitionValue = notesVC.partitionValue
            symptomsVC.isNewNote = true
            symptomsVC.note = Note(textContent: "Add a note...", date: notesVC.date, images: [], symptoms: [], partition: RealmManager.shared.getPartitionValue())
        }
        
    }
    

}
