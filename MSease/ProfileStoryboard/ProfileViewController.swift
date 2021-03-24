//
//  ProfileViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-29.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var containerTableView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Variables
    var partitionValue : String?
    var realm: Realm?
    var nameText = ""
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = nameText
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for child in children{
            if let childVC = child as? ProfileTableViewController{
                childVC.partitionValue = partitionValue
                childVC.realm = realm
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
