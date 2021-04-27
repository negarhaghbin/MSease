//
//  IPIntroViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-26.
//

import UIKit

class IPIntroViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var startButton:UIButton!
    
    // MARK: - Variables
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StylingUtilities.styleFilledButton(startButton)
        StylingUtilities.styleHollowdButton(cancelButton)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any){
        dismiss(animated: true)
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
