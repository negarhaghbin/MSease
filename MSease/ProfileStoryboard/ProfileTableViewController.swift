//
//  ProfileTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-29.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tsqm0: UITableViewCell!
    @IBOutlet weak var tsqm1: UITableViewCell!
    @IBOutlet weak var tsqm2: UITableViewCell!
    
    @IBOutlet weak var tsqm0Image: UIImageView!
    @IBOutlet weak var tsqm0Label: UILabel!
    
    @IBOutlet weak var tsqm1Image: UIImageView!
    @IBOutlet weak var tsqm1Label: UILabel!
    
    @IBOutlet weak var tsqm2Image: UIImageView!
    @IBOutlet weak var tsqm2Label: UILabel!
    
    
    // MARK: - Variables
    var signoutRow = 7
    var partitionValue: String?
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTSQM(version: 0)
        updateTSQM(version: 1)
        updateTSQM(version: 2)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == signoutRow{
            RealmManager.shared.logOut(vc: self)
        }
    }
    
    // MARK: - Helpers
    
    func updateTSQM(version: Int){
        tsqm0.isSelected = false
        tsqm1.isSelected = false
        tsqm2.isSelected = false
        
        if RealmManager.shared.hasTSQM(version: version){
            tsqm0.accessoryType = .checkmark
        }
        if RealmManager.shared.isTSQMLocked(version: version){
            switch version {
            case 0:
                StylingUtilities.styleDisabledCell(tableCell: tsqm0, label: tsqm0Label, imageView: tsqm0Image)
            case 1:
                StylingUtilities.styleDisabledCell(tableCell: tsqm1, label: tsqm1Label, imageView: tsqm1Image)
            case 2:
                StylingUtilities.styleDisabledCell(tableCell: tsqm2, label: tsqm2Label, imageView: tsqm2Image)
            default:
                break
            }
        }
    }
    /*func logOut() {
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
    }*/

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reminders"{
            let remindersVC = segue.destination as! reminderSettingsViewController
            remindersVC.partitionValue = self.partitionValue!
        }
        if let destination = segue.destination as? TSQMViewController{
            if segue.identifier == "TSQM0"{
                destination.TSQMversion = 0
            }
            if segue.identifier == "TSQM1"{
                destination.TSQMversion = 1
            }
            if segue.identifier == "TSQM2"{
                destination.TSQMversion = 2
            }
            
        }
        
    }
    

}


