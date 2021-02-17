//
//  SymptomsPopupViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import UIKit


class SymptomsPopupViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closePopup(_ sender: Any) {
        let notesVC = parent as! NotesTableViewController
        notesVC.symptomsView.animHide()
        notesVC.shadowView.isHidden = true
//        dismiss(animated: true)
    }
    
    @IBAction func addInjectionLogTapped(_ sender: Any) {
    }
    
    @IBAction func addSymptomsLogTapped(_ sender: Any) {
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let notesVC = parent as! NotesTableViewController
        notesVC.symptomsView.animHide()
        notesVC.shadowView.isHidden = true
        
        if segue.identifier == "showAddSymptoms" {
            let symptomsVC = segue.destination as? SymptomsCollectionViewController
            symptomsVC!.date = notesVC.date
        }
    }
    

}
