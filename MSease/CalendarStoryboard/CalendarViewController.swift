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
    
//    lazy var partitionValue = RealmManager.shared.getPartitionValue()
    
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
        calendar.appearance.eventDefaultColor = StylingUtilities.buttonColor
        calendar.appearance.eventSelectionColor = StylingUtilities.buttonColor
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - FSCalendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tabBarController?.tabBar.isHidden = true
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinutes = Calendar.current.component(.minute, from: Date())
        
        selectedDate = Calendar.current.date(bySetting: .hour, value: currentHour, of: calendar.selectedDate!)
        
        selectedDate = Calendar.current.date(bySetting: .minute, value: currentMinutes, of: selectedDate!)
        
        performSegue(withIdentifier: "viewDateSegue", sender: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var result = 0
        if RealmManager.shared.haveNotes(for: date as Date){
            result += 1
        }
        if RealmManager.shared.haveInjections(for: date as Date){
            result += 1
        }
        return result
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        var numberOfEvents = 0
        if RealmManager.shared.haveNotes(for: date as Date){
            cell.eventIndicator.isHidden = false
            numberOfEvents += 1
        }
        if RealmManager.shared.haveInjections(for: date as Date){
            cell.eventIndicator.isHidden = false
            numberOfEvents += 1
        }
        cell.eventIndicator.numberOfEvents = numberOfEvents
    }
    
    
    // MARK: - IBActions
    @IBAction func goToToday(_ sender: Any) {
        calendar.setCurrentPage(Date(), animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.viewDateSegue.rawValue {
            notesViewController = segue.destination as? NotesTableViewController
            
//            notesViewController?.partitionValue = RealmManager.shared.getPartitionValue()
            notesViewController?.date = selectedDate!
        }
    }
    

}
