//
//  InjectionPhobiaViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-06.
//

import UIKit
import DLRadioButton

class InjectionPhobiaViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var options: [DLRadioButton]!
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Variables
    var pageNumber : Int = 0
    var selectedAnswer : String?
    var answers : [String]?
    
    
    // MARK: - Viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        answers = RealmManager.shared.getIP()
        StylingUtilities.styleQuestionnaireView(bgView)
        setupUI()
    }

    // MARK: - Helpers
    func setupUI(){
        questionLabel.text = IPquestions[pageNumber].question
        nextButton.isEnabled = false
        
        for (index, option) in options.enumerated(){
            option.isHidden = false
            option.deselectOtherButtons()
            option.setTitle(IPquestions[pageNumber].options[index], for: .normal)
        }
        
        pageLabel.text = "\(IPquestions[pageNumber].number) of \(IPquestions.count)"
        fillOption(answer: answers![pageNumber])
        if IPquestions[pageNumber].number == IPquestions.count{
            nextButton.setTitle("Submit", for: .normal)
        }
        else{
            nextButton.setTitle("Next", for: .normal)
        }
        
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(backButton)
    }
    
    func fillOption(answer: String){
        if answer=="Not selected"{
            return
        }
        else{
            for option in options{
                if option.titleLabel?.text == answer{
                    option.isSelected = true
                }
            }
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.init(hex: StylingUtilities.buttonColor)
            selectedAnswer = answer
        }
    }
    
    // MARK: - Actions
    @IBAction func nextTapped(_ sender: Any) {
        answers![pageNumber] = selectedAnswer!
        if pageNumber == IPquestions.count-1{
            RealmManager.shared.submitIP(answers: answers!)
            
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
            self.navigationController?.popViewController(animated: true)
//            dismiss(animated: true, completion: nil)
        }
        else{
            pageNumber = pageNumber - 1
            setupUI()
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
