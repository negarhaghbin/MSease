//
//  CalendarViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import FSCalendar
import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // MARK: - IBOutlets
    @IBOutlet var calendar : FSCalendar!
    
    // MARK: - Variables
    var notesViewController: NotesTableViewController?
    var selectedDate : Date?
    var notes : [Note] = []
    
    var partitionValue : String?
    
    enum SegueIdentifier: String {
        case viewDateSegue
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - FSCalendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinutes = Calendar.current.component(.minute, from: Date())
        
        selectedDate = Calendar.current.date(bySetting: .hour, value: currentHour, of: calendar.selectedDate!)
        
        selectedDate = Calendar.current.date(bySetting: .minute, value: currentMinutes, of: selectedDate!)
        
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
    
    
    // MARK: - IBActions
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.viewDateSegue.rawValue {
            notesViewController = segue.destination as? NotesTableViewController
            
            notesViewController?.partitionValue = partitionValue!            
            notesViewController?.date = selectedDate!
        }
    }
    

}
