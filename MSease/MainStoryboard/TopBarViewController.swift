//
//  TopBarViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-17.
//

import UIKit

class TopBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue",
           let parentVC = parent as? MainViewController,
           let destinationVC = segue.destination as? ProfileViewController{
            destinationVC.partitionValue = parentVC.userData?._partition
        }
        else if segue.identifier == "calendarSegue",
            let parentVC = parent as? MainViewController,
            let destinationVC = segue.destination as? CalendarViewController{
                destinationVC.partitionValue = parentVC.userData?._partition
        }
    }
}
