//
//  PretestViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-29.
//

import UIKit
import DLRadioButton

class PretestViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderOptionsStack: UIStackView!
    @IBOutlet weak var typesOptionsStack: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet var genderOptions: [DLRadioButton]!
    @IBOutlet var MSOptions: [DLRadioButton]!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Variables
    var answers = RealmManager.shared.getPretestData()
    var currentIndex = 0
    var selectedAnswer = ""
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleQuestionnaireView(bgView)
        refreshUI()
    }

    // MARK: - Actions
    @IBAction func datePickerChanged(_ sender: Any) {
        selectedAnswer = datePicker.date.getUSFormat()
        answers[currentIndex] = selectedAnswer
    }
    
    @IBAction func optionsTapped(_ sender: DLRadioButton) {
        selectedAnswer = (sender.titleLabel?.text)!
        view.endEditing(true)
        nextButton.isEnabled = true
        nextButton.backgroundColor = StylingUtilities.buttonColor
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        answers[currentIndex] = selectedAnswer
        if currentIndex == pretestQuestions.count-1{
            RealmManager.shared.submitPretestData(answers: answers)
            
            if let _ = presentingViewController{
                dismiss(animated: true)
            }
            else{
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let setReminderVC = storyboard.instantiateViewController(withIdentifier: "setReminderDay") as! OnboardingReminderDayViewController
                navigationController?.setViewControllers([setReminderVC], animated: true)
            }
            /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as! MainViewController

            let navigationViewControllerItems = self.navigationController?.viewControllers
            if navigationViewControllerItems![navigationViewControllerItems!.count-2] is ProfileViewController{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.navigationController?.setViewControllers([homeVC], animated: true)
            }*/
        }
        else{
            currentIndex = currentIndex + 1
            refreshUI()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if currentIndex == 0{
            if let _ = presentingViewController{
                dismiss(animated: true)
            }
            else{
                navigationController?.popViewController(animated: true)
            }
        }
        else{
            currentIndex = currentIndex - 1
            refreshUI()
        }
    }
    
    // MARK: - Helpers
    func fillGenderOptions(answer: String){
        if answer==""{
            return
        }
        else{
            genderOptions[genderOptions.count-1].isSelected = true
            for option in genderOptions{
                if option.titleLabel?.text == answer{
                    option.deselectOtherButtons()
                    option.isSelected = true
                }
            }
            nextButton.isEnabled = true
            nextButton.backgroundColor = StylingUtilities.buttonColor
            selectedAnswer = answer
        }
    }
    
    func fillMSType(answer: String){
        if answer==""{
            return
        }
        else{
            for option in MSOptions{
                if option.titleLabel?.text == answer{
                    option.deselectOtherButtons()
                    option.isSelected = true
                }
            }
            nextButton.isEnabled = true
            nextButton.backgroundColor = StylingUtilities.buttonColor
            selectedAnswer = answer
        }
    }
    
    func fillDatePicker(answer: String){
        if answer==""{
            return
        }
        else{
            datePicker.date = getDateFromString(answer)
            nextButton.isEnabled = true
            nextButton.backgroundColor = StylingUtilities.buttonColor
            selectedAnswer = answer
        }
    }
    
    func refreshUI(){
        titleLabel.text = pretestQuestions[currentIndex].question
        switch currentIndex {
        case Pretest.gender.rawValue:
            hideUIelements(isADate: false, isGender: true)
            fillGenderOptions(answer: answers[currentIndex])
            
        case Pretest.bday.rawValue, Pretest.diagnosedDate.rawValue, Pretest.treatmentDate.rawValue:
            hideUIelements(isADate: true)
            fillDatePicker(answer: answers[currentIndex])
            
        case Pretest.MSType.rawValue:
            hideUIelements(isADate: false, isGender: false)
            fillMSType(answer: answers[currentIndex])
            
        default:
            return
        }
        
        styleButtons()
    }
    
    func styleButtons(){
        if currentIndex == pretestQuestions.count-1{
            nextButton.setTitle("Submit", for: .normal)
        }
        else{
            nextButton.setTitle("Next", for: .normal)
        }
        
        backButton.setTitle("Back", for: .normal)
        if currentIndex == 0{
            if let _ = presentingViewController{
                backButton.setTitle("Cancel", for: .normal)
            }
        }
        
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(backButton)
    }
    
    func hideUIelements(isADate: Bool, isGender: Bool?=false){
        datePicker.isHidden = !isADate
        nextButton.isEnabled = isADate
        if !isADate{
            typesOptionsStack.isHidden = isGender!
            genderOptionsStack.isHidden = !isGender!
        }
        else{
            typesOptionsStack.isHidden = true
            genderOptionsStack.isHidden = true
            selectedAnswer = datePicker.date.getUSFormat()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

// MARK: - UITextFieldDelegate
extension PretestViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        genderOptions[genderOptions.count-1].isSelected = true
        selectedAnswer = textField.text!
    }
    
    // MARK: - Actions
    @IBAction func textFieldChanged(_ sender: Any) {
        selectedAnswer = textField.text!
    }
}
