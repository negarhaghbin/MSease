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
    @IBOutlet var tsqms: [UITableViewCell]!
    @IBOutlet var tsqmImages: [UIImageView]!
    @IBOutlet var tsqmLabels: [UILabel]!
    
    @IBOutlet weak var ipCell: UITableViewCell!
    @IBOutlet weak var generalCell: UITableViewCell!
    
    // MARK: - Variables
    struct cell {
        static let generalData = IndexPath(row:0, section: 1)
        static let ipQuestionnaire = IndexPath(row:1, section: 1)
        static let technicalSupport = IndexPath(row:1, section: 2)
        static let signout = IndexPath(row:0, section: 3)
    }
    
    var partitionValue: String?
    
    var alertMessage = (title: "", message: "")
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateForms()
    }
    
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == cell.signout{
            RealmManager.shared.logOut(vc: self)
        }
        else if indexPath == cell.technicalSupport{
            showMailComposer()
        }
        else if indexPath == cell.generalData{
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "pretestVC")
            present(vc, animated: true)
        }
        else if indexPath == cell.ipQuestionnaire{
            let storyboard = UIStoryboard(name: "TSQM", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "injectionPhobiaVC")
            present(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Helpers
    
    func updateForms(){
        updateGeneral()
        updateIP()
        updateTSQMs()
    }
    
    func updateGeneral(){
        generalCell.isSelected = false
        if RealmManager.shared.hasGeneralData(){
            generalCell.accessoryType = .checkmark
        }
    }
    
    func updateIP(){
        ipCell.isSelected = false
        if RealmManager.shared.hasInjectionPhobiaForm(){
            ipCell.accessoryType = .checkmark
        }
    }
    
    func updateTSQMs(){
        for (version, tsqm) in tsqms.enumerated(){
            tsqm.isSelected = false
            if RealmManager.shared.hasTSQM(version: version){
                tsqm.accessoryType = .checkmark
            }
            if RealmManager.shared.isTSQMLocked(version: version){
                StylingUtilities.styleDisabledCell(tableCell: tsqm, label: tsqmLabels[version], imageView: tsqmImages[version])
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


