//
//  CalendarViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import FSCalendar
import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate {
    @IBOutlet var calendar : FSCalendar!
    @IBOutlet var symptomsView : UIView!
    var containerViewController: SymptomsPopupViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        symptomsView.addShadow()
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if symptomsView.isHidden{
            symptomsView.animShow()
        }
        containerViewController?.changeTitle(newTitle: calendar.selectedDate?.getUSFormat() ?? "")
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        if !symptomsView.isHidden{
//            symptomsView.animHide()
//        }
//    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue" {
            containerViewController = segue.destination as? SymptomsPopupViewController
        }
        // Pass the selected object to the new view controller.
    }
    

}
