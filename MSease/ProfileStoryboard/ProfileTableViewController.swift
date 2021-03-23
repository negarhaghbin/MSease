//
//  ProfileTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-29.
//

import UIKit
import RealmSwift

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Variables
    enum rows : Int {
        case reminders = 0
        case settings
        case logout
    }
    
    var partitionValue: String?
    var realm: Realm?
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == rows.logout.rawValue{
            logOut()
        }
    }
    
    // MARK: - Helpers
    func logOut() {
        let alertController = UIAlertController(title: "Log Out", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Log Out", style: .destructive, handler: {
            _ -> Void in
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                    let onboardingVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
                    RealmManager.shared.removeCredentials()
                    onboardingVC.walkthroughPageViewController?.currentIndex = walkthroughPages.count - 1
                    self.navigationController?.setViewControllers([onboardingVC], animated: true)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reminders"{
            let remindersVC = segue.destination as! reminderSettingsViewController
            remindersVC.partitionValue = self.partitionValue!
            remindersVC.realm = self.realm
        }
        
    }
    

}
