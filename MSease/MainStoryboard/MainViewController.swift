//
//  MainViewController.swift
//  ARKitInteraction
//
//  Created by Negar on 2021-01-25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet weak var injectButton: UIButton!
    @IBOutlet var calendar : FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.pagingEnabled = true
        calendar.scope = .week
        calendar.scrollDirection = .horizontal
        calendar.select(calendar.today)
        // Do any additional setup after loading the view.
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("here")
        if calendar.today != date{
            injectButton.setTitle("Log Symptoms", for: .normal)
        }
        else{
            injectButton.setTitle("Inject", for: .normal)
        }
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
