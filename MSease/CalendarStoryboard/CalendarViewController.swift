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
    var notes : [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinutes = Calendar.current.component(.minute, from: Date())
        
        selectedDate = Calendar.current.date(bySetting: .hour, value: currentHour, of: calendar.selectedDate!)
        
        selectedDate = Calendar.current.date(bySetting: .minute, value: currentMinutes, of: selectedDate!)
        
//        print(selectedDate)
        
        performSegue(withIdentifier: "viewDateSegue", sender: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if RealmManager.shared.haveNotes(for: date as Date){
            return 1
        }
        else{
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if RealmManager.shared.haveNotes(for: date as Date){
            cell.eventIndicator.isHidden = false
            cell.eventIndicator.numberOfEvents = 1
        }
        
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDateSegue" {
            notesViewController = segue.destination as? NotesTableViewController
            notesViewController?.date = selectedDate!
        }
    }
    

}
