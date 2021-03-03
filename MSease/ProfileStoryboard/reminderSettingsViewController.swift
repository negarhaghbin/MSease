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

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "reminderSettingsCell"
    
    var reminders = RealmManager.shared.getReminders()
    var selectedReminder : Reminder? = Reminder()
    var isNewReminder = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reminders"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reminders = RealmManager.shared.getReminders()
        tableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddNewReminderViewController
        vc.reminder = selectedReminder
        vc.isNewReminder = isNewReminder
        // Pass the selected object to the new view controller.
    }
    

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
        if section == 0{
            return 1
        }
        else{
            return reminders.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? reminderSettingsTableViewCell{
            if indexPath.section == 0{
                cell.setup(isReminderInstance: false)
            }
            else if indexPath.section == 1{
                cell.setup(isReminderInstance: true)
                cell.reminderNameLabel.text = reminders[indexPath.row].name
                cell.reminderTimeLabel.text = reminders[indexPath.row].time
                cell.reminderRepeatLabel.text = reminders[indexPath.row].getRepeatationDays()
            }
            return cell
        }
        
        return reminderSettingsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1{
            selectedReminder = reminders[indexPath.row]
            isNewReminder = false
        }
        else{
            selectedReminder = Reminder()
            isNewReminder = true
        }
        return indexPath
    }
    
}
