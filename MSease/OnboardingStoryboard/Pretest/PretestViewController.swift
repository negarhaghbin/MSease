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
    
//    @IBOutlet weak var maleButton: DLRadioButton!
//    @IBOutlet weak var femaleButton: DLRadioButton!
//    @IBOutlet weak var nonbinaryButton: DLRadioButton!
    @IBOutlet weak var otherButton: DLRadioButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Variables
    var answers = Array(repeating: "Not selected", count: pretestQuestions.count)
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
        refreshUI()
    }

    // MARK: - Actions
    @IBAction func optionsTapped(_ sender: DLRadioButton) {
        selectedAnswer = (sender.titleLabel?.text)!
        self.view.endEditing(true)
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.init(hex: "#61A5C2FF")
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        answers[currentIndex] = selectedAnswer
        if currentIndex == pretestQuestions.count-1{
            RealmManager.shared.submitPretestData(answers: answers)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as! MainViewController

            self.navigationController?.setViewControllers([homeVC], animated: true)
        }
        else{
            currentIndex = currentIndex + 1
            refreshUI()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if currentIndex == 0{
            self.navigationController?.popViewController(animated: true)
            //dismiss(animated: true, completion: nil)
        }
        else{
            currentIndex = currentIndex - 1
            refreshUI()
        }
    }
    
    // MARK: - Helpers
    func refreshUI(){
        titleLabel.text = pretestQuestions[currentIndex].question
        switch currentIndex {
        case Pretest.gender.rawValue:
            hideUIelements(isADate: false, isGender: true)
        case Pretest.bday.rawValue:
            hideUIelements(isADate: true)
        case Pretest.MSType.rawValue:
            hideUIelements(isADate: false, isGender: false)
        case Pretest.diagnosedDate.rawValue:
            hideUIelements(isADate: true)
        case Pretest.treatmentDate.rawValue:
            hideUIelements(isADate: true)
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
        otherButton.isSelected = true
        selectedAnswer = textField.text!
    }
    
    // MARK: - Actions
    @IBAction func textFieldChanged(_ sender: Any) {
        selectedAnswer = textField.text!
    }
}
