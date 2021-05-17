//
//  reminderSettingsViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-16.
//

import UIKit
import RealmSwift

// MARK: - Reminder Table View Cell
class reminderSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var reminderNameLabel: UILabel!
    @IBOutlet weak var reminderRepeatLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    @IBOutlet weak var addNewReminderLabel: UILabel!
    @IBOutlet weak var activationSwitch: UISwitch!
    
    func setup(isReminderInstance: Bool, reminder: Reminder? = nil, row: Int? = 0){
        self.addNewReminderLabel.textColor = StylingUtilities.buttonColor
        self.addNewReminderLabel.isHidden = isReminderInstance
        self.reminderTimeLabel.isHidden = !isReminderInstance
        self.reminderNameLabel.isHidden = !isReminderInstance
        self.reminderRepeatLabel.isHidden = !isReminderInstance
        self.activationSwitch.isHidden = !isReminderInstance
        
        if isReminderInstance{
            self.activationSwitch.isOn = reminder!.isOn
            self.activationSwitch.tag = row!
            
            self.reminderNameLabel.text = reminder!.name
            self.reminderTimeLabel.text = reminder!.time
            self.reminderRepeatLabel.text = reminder!.getRepeatationDays()
            
        }
        
    }
    
}

// MARK: - Reminders UIViewController
class reminderSettingsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    let cellIdentifier = "reminderSettingsCell"
    var selectedReminder : Reminder? = Reminder()
    var isNewReminder = true
    
    lazy var partitionValue = RealmManager.shared.getPartitionValue()

    var notificationToken: NotificationToken?
    var reminders = RealmManager.shared.getReminders()
    
    let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Initialization
    deinit {
        notificationToken?.invalidate()
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initSetup(title: "Reminders")
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Helpers
    func initSetup(title: String) {
        
        self.title = title

        notificationToken = reminders.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 1) }),
                        with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 1) }),
                        with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 1) }),
                        with: .automatic)
                })
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func switchTapped(_ sender: UISwitch) {
        RealmManager.shared.changeReminderState(reminder: reminders[sender.tag], state: sender.isOn)
        if sender.isOn{
            scheduleNotification(reminder: reminders[sender.tag])
        }
        else{
            for i in 0...6{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminders[sender.tag]._id.stringValue+"\(i)"])
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewReminderViewController{
            vc.partitionValue = partitionValue
            vc.reminder = selectedReminder
            vc.isNewReminder = isNewReminder
        }
    }
}

// MARK: - Reminders UITableViewController
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
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1{
            if reminders.count == 0{
                return "You have no reminders."
            }
        }
        return ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? reminderSettingsTableViewCell
        if indexPath.section == 0{
            cell!.setup(isReminderInstance: false)
        }
        else if indexPath.section == 1{
            cell!.setup(isReminderInstance: true, reminder: reminders[indexPath.row], row: indexPath.row)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 1{
            selectedReminder = reminders[indexPath.row]
            isNewReminder = false
        }
        else{
            selectedReminder = Reminder()
            isNewReminder = true
        }
        performSegue(withIdentifier: "showReminderEditor", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            for i in 0...6{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminders[indexPath.row]._id.stringValue+"\(i)"])
            }
            RealmManager.shared.removeReminder(reminder: reminders[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }
        else{
            return true
        }
    }
    
}
