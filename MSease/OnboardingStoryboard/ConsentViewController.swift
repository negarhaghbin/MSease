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
    
    // MARK: - Variables
    var userRealm: Realm?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        StylingUtilities.styleAcceptButton(acceptButton)
        StylingUtilities.styleCancelButton(cancelButton)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        RealmManager.shared.logOut(vc: self)
    }
    @IBAction func acceptButton(_ sender: Any) {
        RealmManager.shared.acceptConsent(realm: userRealm!)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PretestViewController{
            destination.realm = userRealm
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

