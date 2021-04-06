//
//  TypeOfMSViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-30.
//

import UIKit
import DLRadioButton

class TypeOfMSViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        StylingUtilities.styleFilledButton(nextButton)
    }
    
    @IBAction func buttonTapped(_ sender: DLRadioButton) {
        selectedType = sender.titleLabel?.text
        nextButton.isEnabled = true
        
        // TODO: go to tsqm questionnaire?
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
