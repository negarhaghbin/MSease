//
//  SymptomsPopupViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-26.
//

import UIKit


class SymptomsPopupViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var popUpTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closePopup(_ sender: Any) {
        let calendarVC = parent as! CalendarViewController
        calendarVC.symptomsView.animHide()
        calendarVC.calendar.deselect(calendarVC.calendar.selectedDate!)
    }
    
    @IBAction func addSymptom(_ sender: Any) {
    }
    
    func changeTitle(newTitle: String){
        popUpTitle.text = newTitle
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
