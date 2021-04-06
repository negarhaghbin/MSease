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
    
    @IBOutlet weak var option1: DLRadioButton!
    @IBOutlet weak var option2: DLRadioButton!
    @IBOutlet weak var option3: DLRadioButton!
    @IBOutlet weak var option4: DLRadioButton!
    @IBOutlet weak var option5: DLRadioButton!
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Variables
    var pageNumber : Int = 0
    var selectedAnswer : String?
    var answers : [String]?
    
    
    // MARK: - Viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        answers = RealmManager.shared.getIP()
        setupUI()
    }

    // MARK: - Helpers
    func setupUI(){
        questionLabel.text = IPquestions[pageNumber].question
        nextButton.isEnabled = false
            
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
            
            
        option1.setTitle(IPquestions[pageNumber].options[0], for: .normal)
        option2.setTitle(IPquestions[pageNumber].options[1], for: .normal)
        option3.setTitle(IPquestions[pageNumber].options[2], for: .normal)
        option4.setTitle(IPquestions[pageNumber].options[3], for: .normal)
        option5.setTitle(IPquestions[pageNumber].options[4], for: .normal)
        
        pageLabel.text = "\(IPquestions[pageNumber].number) of \(IPquestions.count)"
        fillOption(answer: answers![pageNumber])
        if IPquestions[pageNumber].number == 14{
            nextButton.setTitle("Submit", for: .normal)
        }
        else{
            nextButton.setTitle("Next", for: .normal)
        }
        
        if IPquestions[pageNumber].number == 1{
            backButton.setTitle("Cancel", for: .normal)
        }
        else{
            backButton.setTitle("Back", for: .normal)
        }
        
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(backButton)
    }
    
    func fillOption(answer: String){
        if answer=="Not selected"{
            return
        }
        else{
            switch answer {
            case option1.titleLabel?.text:
                option1.isSelected = true
            case option2.titleLabel?.text:
                option2.isSelected = true
            case option3.titleLabel?.text:
                option3.isSelected = true
            case option4.titleLabel?.text:
                option4.isSelected = true
            case option5.titleLabel?.text:
                option5.isSelected = true
            
            default:
                break
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
