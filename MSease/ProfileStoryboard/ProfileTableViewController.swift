//
//  ProfileTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-29.
//

import UIKit
import MessageUI

class ProfileTableViewController: UITableViewController{
    
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
    enum rows: Int{
        case technicalSupport = 3
        case signout = 7
    }
    var partitionValue: String?
    
    var alertMessage = (title: "", message: "")
    
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
        if indexPath.row == rows.signout.rawValue{
            RealmManager.shared.logOut(vc: self)
        }
        else if indexPath.row == rows.technicalSupport.rawValue{
            showMailComposer()
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func showMailComposer(){
        guard MFMailComposeViewController.canSendMail() else{
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["nbeanm@gmail.com"])
        composer.setSubject("technical support needed!")
        
        present(composer, animated: true)
    }

    
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

extension ProfileTableViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error{
            self.alertMessage.title = "Error"
            self.alertMessage.message = "\(error)"
        }
        else{
            switch result {
            case .sent:
                self.alertMessage.title = "Message sent"
                self.alertMessage.message = "Your email is successfuly sent."
            case .saved:
                self.alertMessage.title = "Message saved"
                self.alertMessage.message = "The email was saved in your drafts folder."
                
            default:
                print("canceled.")
            }
        }
        controller.dismiss(animated: true, completion: {
            if self.alertMessage.title != ""{
                let alert = UIAlertController(title: self.alertMessage.title, message: self.alertMessage.message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                    self.dismiss(animated: true)
                    self.alertMessage.title = ""
                    self.alertMessage.message = ""
                }))

                self.present(alert, animated: true)
            }
        })
        return
    }
}


