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
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == rows.reminders.rawValue{
            let user = app.currentUser!
            Realm.asyncOpen(configuration: user.configuration(partitionValue: partitionValue!)) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    fatalError("Failed to open realm: \(error)")
                case .success(let realm):
                    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                    let remindersVC = storyboard.instantiateViewController(withIdentifier: "reminderList") as? reminderSettingsViewController
                    remindersVC?.partitionValue = self!.partitionValue!
                    remindersVC?.realm = realm
                    self?.navigationController?.pushViewController(
                        remindersVC!,
                        animated: true
                    )
                }
            }
        }
        return indexPath
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
                    self.navigationController?.setViewControllers([onboardingVC], animated: true)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }

    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }*/
    

}
