//
//  OnboardingReminderDayViewController.swift
//  MSease
//
//  Created by Negar on 2021-06-23.
//

import UIKit

class OnboardingReminderDayViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet var dayOptions: [UIButton]!
    
    // MARK: - Variables
    
    enum buttonTags : Int{
        case mon = 0
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
        case none
    }
    
    var selectedDays = [false, false, false, false, false, false, false]
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(cancelButton)
        StylingUtilities.styleQuestionnaireView(bgView)
    }
    
    // MARK: - Actions
    @IBAction func daySelected(_ sender: UIButton){
        if sender.tag == buttonTags.none.rawValue {
            for (index,day) in dayOptions.enumerated(){
                day.layer.borderWidth = 0
                selectedDays[index] = false
            }
        }
        else{
            if sender.layer.borderWidth == 1{
                unselectDay(sender)
            }
            else{
                selectDay(sender)
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any){
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "setReminder") as! onboardingReminderViewController
        vc.selectedDays = selectedDays
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as! MainViewController
        self.navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    // MARK: - Helpers
    func unselectDay(_ sender: UIButton){
        sender.layer.borderWidth = 0
        let dayIndex = sender.tag
        selectedDays[dayIndex] = false
    }
    
    func selectDay(_ sender: UIButton){
        sender.layer.borderWidth = 1
        sender.layer.borderColor = StylingUtilities.buttonColor?.cgColor
        let dayIndex = sender.tag
        selectedDays[dayIndex] = true
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
