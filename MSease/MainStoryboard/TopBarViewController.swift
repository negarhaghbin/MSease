//
//  TopBarViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-17.
//

import UIKit
import RealmSwift

class TopBarViewController: UIViewController {

    var realm : Realm?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let parentVC = parent as? MainViewController
        if segue.identifier == "profileSegue",
           let destinationVC = segue.destination as? ProfileViewController{
            destinationVC.partitionValue = parentVC!.userData?._partition
            destinationVC.realm = realm
        }
        else if segue.identifier == "calendarSegue",
            let destinationVC = segue.destination as? CalendarViewController{
            destinationVC.partitionValue = parentVC!.userData?._partition
            destinationVC.realm = realm
        }
    }
}
