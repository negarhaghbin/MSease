//
//  ConsentViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-12.
//

import UIKit
import RealmSwift

class ConsentViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var consentSwitch: UISwitch!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var upperView: UIView!
    
    // MARK: - ViewController
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        StylingUtilities.styleFilledButton(acceptButton)
        StylingUtilities.styleHollowdButton(cancelButton)
        upperView.backgroundColor = StylingUtilities.buttonColor
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        RealmManager.shared.logOut(vc: self)
    }
    @IBAction func acceptButton(_ sender: Any) {
        RealmManager.shared.acceptConsent()
    }
    
    @IBAction func switchOnValueChange(_ sender: UISwitch) {
        if sender.isOn{
            acceptButton.isEnabled = true
        }
        else{
            acceptButton.isEnabled = false
        }
        StylingUtilities.styleFilledButton(acceptButton)
    }
    
   /* // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}

