//
//  TSQMViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-01.
//

import UIKit
import DLRadioButton

class TSQMViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var option1: DLRadioButton!
    @IBOutlet weak var option2: DLRadioButton!
    @IBOutlet weak var option3: DLRadioButton!
    @IBOutlet weak var option4: DLRadioButton!
    @IBOutlet weak var option5: DLRadioButton!
    @IBOutlet weak var option6: DLRadioButton!
    @IBOutlet weak var option7: DLRadioButton!
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Variables
    var pageNumber : Int = 0
    var selectedAnswer : String?
    var TSQMversion : Int?
    var answers : [String]?
    
    
    // MARK: - Viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        answers = RealmManager.shared.getTSQM(version: TSQMversion!)
        setupUI()
    }

    // MARK: - Helpers
    func setupUI(){
        questionLabel.text = TSQMquestions[pageNumber].question
        nextButton.isEnabled = false
        
        if TSQMquestions[pageNumber].options.count>0{
            textView.isHidden = true
            
            option1.isHidden = false
            option1.deselectOtherButtons()
            
            option2.isHidden = false
            option2.deselectOtherButtons()
            
            option3.isHidden = false
            option3.deselectOtherButtons()
            
            option4.isHidden = false
            option4.deselectOtherButtons()
            
            option5.isHidden = false
            option5.deselectOtherButtons()
            
            option6.isHidden = false
            option6.deselectOtherButtons()
            
            option7.isHidden = false
            option7.deselectOtherButtons()
            
            option1.setTitle(TSQMquestions[pageNumber].options[0], for: .normal)
            option2.setTitle(TSQMquestions[pageNumber].options[1], for: .normal)
            option3.setTitle(TSQMquestions[pageNumber].options[2], for: .normal)
            option4.setTitle(TSQMquestions[pageNumber].options[3], for: .normal)
            option5.setTitle(TSQMquestions[pageNumber].options[4], for: .normal)
            option6.setTitle(TSQMquestions[pageNumber].options[5], for: .normal)
            option7.setTitle(TSQMquestions[pageNumber].options[6], for: .normal)
        }
        else{
            textView.isHidden = false
            option1.isHidden = true
            option2.isHidden = true
            option3.isHidden = true
            option4.isHidden = true
            option5.isHidden = true
            option6.isHidden = true
            option7.isHidden = true
        }
        
        
        pageLabel.text = "\(TSQMquestions[pageNumber].number) of \(TSQMquestions.count)"
        fillOption(answer: answers![pageNumber])
        if TSQMquestions[pageNumber].number == 14{
            nextButton.setTitle("Submit", for: .normal)
        }
        else{
            nextButton.setTitle("Next", for: .normal)
        }
        
        if TSQMquestions[pageNumber].number == 1{
            backButton.setTitle("Cancel", for: .normal)
        }
        else{
            backButton.setTitle("Back", for: .normal)
        }
        
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(backButton)
    }
    
    @objc func dismissKeyboard() {
        textView.endEditing(true)
    }
    
    func fillOption(answer: String){
        if answer=="Not selected"{
            return
        }
        else{
            switch answer {
            case option1.titleLabel?.text:
                option1.isSelected = true
//                optionTapped(option1)
            case option2.titleLabel?.text:
                option2.isSelected = true
//                optionTapped(option2)
            case option3.titleLabel?.text:
                option3.isSelected = true
//                optionTapped(option3)
            case option4.titleLabel?.text:
                option4.isSelected = true
//                optionTapped(option4)
            case option5.titleLabel?.text:
                option5.isSelected = true
//                optionTapped(option5)
            case option6.titleLabel?.text:
                option6.isSelected = true
//                optionTapped(option6)
            case option7.titleLabel?.text:
                option7.isSelected = true
//                optionTapped(option7)
            
            default:
                textView.text = answer
                textView.textColor = UIColor.label
            }
            
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.init(hex: "#61A5C2FF")
            selectedAnswer = answer
        }
    }
    
    // MARK: - Actions
    @IBAction func nextTapped(_ sender: Any) {
        answers![pageNumber] = selectedAnswer!
        if pageNumber == 13{
            RealmManager.shared.submitTSQM(version: TSQMversion!, answers: answers!)
            
            dismiss(animated: true, completion: nil)
        }
        else{
            pageNumber = pageNumber + 1
            setupUI()
        }
        
    }
    
    @IBAction func optionTapped(_ sender: DLRadioButton) {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.init(hex: "#61A5C2FF")
        selectedAnswer = sender.titleLabel?.text
    }
    
    @IBAction func backTapped(_ sender: Any) {
        if pageNumber == 0{
            dismiss(animated: true, completion: nil)
        }
        else{
            pageNumber = pageNumber - 1
            setupUI()
        }
    }
    
    

    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProfileViewController{
            destination.pageNumber = pageNumber+1
        }
    }*/

}

extension TSQMViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.init(hex: "#61A5C2FF")
        selectedAnswer = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText{
            textView.text = ""
            textView.textColor = UIColor.label
        }
        
    }
}
