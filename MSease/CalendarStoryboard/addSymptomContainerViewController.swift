//
//  addSymptomContainerViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import UIKit

class addSymptomContainerViewController: UIViewController {
    
    var selectedSymptoms : [Symptom] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //symptomTrackingJournal, date , symptoms
        let symptomsVC = parent as! SymptomsCollectionViewController
        
        let cell = symptomsVC.mainCollectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as! NotesCollectionViewCell
        let note = Note(textContent: cell.noteTextView.text, date: symptomsVC.date)
        RealmManager.shared.addNote(newNote: note)
        self.navigationController?.popViewController(animated: true)
    }
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}
