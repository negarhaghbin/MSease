//
//  CalendarViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import FSCalendar
import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    @IBOutlet var calendar : FSCalendar!
    var notesViewController: NotesTableViewController?
    var selectedDate : Date?
    var notes : [Note]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = calendar.selectedDate
        performSegue(withIdentifier: "viewDateSegue", sender: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print(date)
        notes = RealmManager.shared.getNotes(for: date as Date)
        return notes!.count == 0 ? 0 : 1
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        notes = RealmManager.shared.getNotes(for: date as Date)
        if notes!.count != 0{
            cell.eventIndicator.isHidden = false
            cell.eventIndicator.numberOfEvents = 1
        }
        
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDateSegue" {
            notesViewController = segue.destination as? NotesTableViewController
            notesViewController?.date = selectedDate!
            notesViewController?.notes = notes!
        }
        // Pass the selected object to the new view controller.
    }
    

}
