//
//  reminderSettingsViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-16.
//

import UIKit

class reminderSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var reminderNameLabel: UILabel!
    @IBOutlet weak var reminderRepeatLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var addNewReminderLabel: UILabel!
    
    func setup(isReminderInstance: Bool){
        self.addNewReminderLabel.isHidden = isReminderInstance
        self.reminderTimeLabel.isHidden = !isReminderInstance
        self.reminderNameLabel.isHidden = !isReminderInstance
        self.reminderRepeatLabel.isHidden = !isReminderInstance
    }
}

class reminderSettingsViewController: UIViewController {

    let cellIdentifier = "reminderSettingsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension reminderSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        else{
            return "Reminders"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reminders.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? reminderSettingsTableViewCell{
            if indexPath.section == 0{
                cell.setup(isReminderInstance: false)
            }
            else if indexPath.section == 1{
                cell.setup(isReminderInstance: true)
                cell.reminderNameLabel.text = "New Reminder"
                cell.reminderTimeLabel.text = "1:24 PM"
            }
            return cell
        }
        
        return reminderSettingsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
}
