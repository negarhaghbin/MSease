//
//  ProfileTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-29.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Variables
    enum rows : Int {
        case reminders = 0
        case settings
        case logout
    }
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
            print("Logging out...")
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    print("Logged out!")
                    // TODO: Do logout
//                    self.navigationController?.popViewController(animated: true)
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
