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
    @IBOutlet var options: [DLRadioButton]!
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
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
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        textView.inputAccessoryView = toolbar
        StylingUtilities.styleQuestionnaireView(bgView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        answers = RealmManager.shared.getTSQM(version: TSQMversion!)
        setupUI()
    }

    // MARK: - Helpers
    func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
        questionLabel.text = TSQMquestions[pageNumber].question
        nextButton.isEnabled = false
        
        if TSQMquestions[pageNumber].options.count>0{
            textView.isHidden = true
            
            for (index, option) in options.enumerated(){
                option.isHidden = false
                option.deselectOtherButtons()
                option.setTitle(TSQMquestions[pageNumber].options[index], for: .normal)
            }
        }
        else{
            textView.isHidden = false
            for option in options{
                option.isHidden = true
            }
        }
        
        
        pageLabel.text = "\(TSQMquestions[pageNumber].number) of \(TSQMquestions.count)"
        fillOption(answer: answers![pageNumber])
        
        styleButtons()
    }
    
    func styleButtons(){
        if TSQMquestions[pageNumber].number == TSQMquestions.count{
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
            var isOptionFound = false
            for option in options{
                if option.titleLabel?.text == answer{
                    option.isSelected=true
                    isOptionFound = true
                }
            }
            if !isOptionFound{
                textView.text = answer
                textView.textColor = UIColor.label
                isOptionFound = true
            }
            
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.init(hex: StylingUtilities.buttonColor)
            selectedAnswer = answer
        }
    }
    
    // MARK: - Actions
    @IBAction func nextTapped(_ sender: Any) {
        answers![pageNumber] = selectedAnswer!
        if pageNumber == TSQMquestions.count-1{
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
        nextButton.backgroundColor = UIColor.init(hex: StylingUtilities.buttonColor)
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
        nextButton.backgroundColor = UIColor.init(hex: StylingUtilities.buttonColor)
        selectedAnswer = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText{
            textView.text = ""
            textView.textColor = UIColor.label
        }
        
    }
}
