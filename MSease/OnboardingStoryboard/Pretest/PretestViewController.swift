//
//  PretestViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-29.
//

import UIKit
import RealmSwift
import DLRadioButton

class PretestViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var maleButton: DLRadioButton!
    @IBOutlet weak var femaleButton: DLRadioButton!
    @IBOutlet weak var nonbinaryButton: DLRadioButton!
    @IBOutlet weak var otherButton: DLRadioButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedGender : String?{
        didSet{
            print(selectedGender)
        }
    }
    
    var realm: Realm?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        StylingUtilities.styleFilledButton(nextButton)
    }

    @IBAction func buttonTapped(_ sender: DLRadioButton) {
        selectedGender = sender.titleLabel?.text
        self.view.endEditing(true)
        nextButton.isEnabled = true
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

extension PretestViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        otherButton.isSelected = true
        selectedGender = textField.text
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        selectedGender = textField.text
    }
}
