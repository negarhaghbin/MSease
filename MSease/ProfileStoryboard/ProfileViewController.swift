//
//  ProfileViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-29.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var containerTableView: UIView!
    // MARK: - Variables
    var partitionValue : String?
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for child in children{
            if let childVC = child as? ProfileTableViewController{
                childVC.partitionValue = partitionValue
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
