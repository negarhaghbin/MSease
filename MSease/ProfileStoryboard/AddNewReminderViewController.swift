//
//  AddNewReminderViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-16.
//

import UIKit
import RealmSwift

let daysOfTheWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
class AddNewReminderViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet var days: Array<UITableViewCell>?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Variables
    var isNewReminder = false
    var repeatDays : [Bool] = []
    var reminder : Reminder? {
        didSet {
            refreshUI()
        }
    }
    
    enum rows : Int{
        case name = 0
        case nameTextField
        case repeatRow
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
        case time
        case timePicker
        case message
        case messageTextView
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var partitionValue: String?
    var realm: Realm?{
        didSet{
            initSetup(title: "Add new reminder")
        }
    }
//    var notificationToken: NotificationToken?

//    deinit {
//        // Always invalidate any notification tokens when you are done with them.
//        notificationToken?.invalidate()
//    }
    
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isNewReminder{
            self.navigationItem.title = "Add a new reminder"
        }
        else{
            self.navigationItem.title = "Edit reminder"
        }
        for (i,day) in repeatDays.enumerated(){
            if day == true{
                days![i].accessoryType = .checkmark
            }
            else{
                days![i].accessoryType = .none
            }
        }
    }
    
    // MARK: - Helpers
    
    func initSetup(title: String) {
        guard let syncConfiguration = realm?.configuration.syncConfiguration else {
            fatalError("Sync configuration not found! Realm not opened with sync?")
        }
        partitionValue = syncConfiguration.partitionValue!.stringValue!
        self.title = title

    }
    
    private func refreshUI(){
        loadView()
        nameLabel.text = reminder?.name
        repeatLabel.text = reminder?.getRepeatationDays()
        messageLabel.text = reminder?.message
        nameTextField.text = reminder?.name
        repeatDays = (reminder?.getRepeatDaysList())!
        textView.text = reminder?.message
        
        
        timeLabel.text = reminder?.time == "" ? Date().getTime() : reminder?.time
        let time = getTimeFromString(timeLabel.text!)
        timePicker.date = Date().setTime(h: time.h, m: time.m)
        
        tableView.reloadData()
    }
    
    func AnimateTableCell(indexPath: IndexPath){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
    
    func setRepeatLabel(){
        var repeatValue = ""
        var counter = 0
        for (i,day) in repeatDays.enumerated(){
            if day == true{
                repeatValue += "\(daysOfTheWeek[i]), "
                counter += 1
            }
        }
        if counter == 0{
            repeatValue = "Choose a day"
            saveButton.isEnabled = false
            
        }
        else if counter == 7{
            repeatValue = "Daily"
            saveButton.isEnabled = true
        }
        else{
            saveButton.isEnabled = true
            repeatValue.remove(at: repeatValue.index(before: repeatValue.endIndex))
            repeatValue.remove(at: repeatValue.index(before: repeatValue.endIndex))
        }
        
        repeatLabel.text = repeatValue
    }
    
    // MARK: - Actions
    
    @IBAction func addReminder(_ sender: Any) {
        let reminderId = (reminder?._id)!
        reminder = Reminder(name: nameLabel.text ?? "",
                            mon: repeatDays[0],
                            tue: repeatDays[1],
                            wed: repeatDays[2],
                            thu: repeatDays[3],
                            fri: repeatDays[4],
                            sat: repeatDays[5],
                            sun: repeatDays[6],
                            time: timeLabel.text!,
                            message: textView.text, partition: partitionValue!)
        if isNewReminder{
            RealmManager.shared.addReminder(newReminder: reminder!, realm: realm!)
        }
        else{
            reminder?.setId(id: reminderId)
            RealmManager.shared.editReminder(reminder!, realm: realm!)
        }
        
        self.scheduleNotification(name: nameLabel.text ?? "", message: textView.text)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIDatePickerView
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        timeLabel.text = sender.date.getTime()
    }
    
    // MARK: - Text Field
    
    @IBAction func textFieldChanged(_ sender: Any) {
        nameLabel.text = nameTextField.text
    }
    
    
    // MARK: - Text View
    
    func textViewDidChange(_ textView: UITextView) {
        messageLabel.text = textView.text
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case rows.time.rawValue:
            timePicker.isHidden = !timePicker.isHidden
            
        case rows.message.rawValue:
            textView.isHidden = !textView.isHidden
            if textView.isHidden{
                textView.resignFirstResponder()
            }
            
        case rows.repeatRow.rawValue:
            for cell in days!{
                cell.isHidden = !cell.isHidden
            }
        case rows.mon.rawValue...rows.sun.rawValue:
            let dayIndex = indexPath.row-rows.mon.rawValue
            let cell = days![dayIndex]
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                repeatDays[dayIndex] = false
            }
            else{
                cell.accessoryType = .checkmark
                repeatDays[dayIndex] = true
            }
            
            setRepeatLabel()
            
            
        case rows.name.rawValue:
            nameTextField.isHidden = !nameTextField.isHidden
            nameLabel.text = nameTextField.text
            nameTextField.resignFirstResponder()
                        
        default:
            break
        }
        AnimateTableCell(indexPath: indexPath)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == rows.timePicker.rawValue {
            let height:CGFloat = timePicker.isHidden ? 0.0 : 216.0
            return height
        }
        
        if indexPath.row == rows.messageTextView.rawValue {
            let height:CGFloat = textView.isHidden ? 0.0 : 216.0
            return height
        }
        
        for i in rows.mon.rawValue...rows.sun.rawValue{
            if indexPath.row == i {
                let height:CGFloat = days![i-rows.mon.rawValue].isHidden ? 0.0 : 46.0
                return height
            }
        }
        
        if indexPath.row == rows.nameTextField.rawValue {
            let height:CGFloat = nameTextField.isHidden ? 0.0 : 60.0
            return height
        }

        return CGFloat(46.0)
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

// MARK: - Push Notifications
extension AddNewReminderViewController : UNUserNotificationCenterDelegate{
    
    func scheduleNotification(name: String, message: String){
        let time = getTimeFromString(timeLabel.text!)
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = message
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notificationCategory.snoozable.rawValue

        // i = 0,monday
        // weekday = 1, sunday
        
        //i = 6, weekday = 1
        var triggerRepeat = Calendar.current.dateComponents([.weekday,.hour, .minute], from: Date())
        triggerRepeat.hour = time.h
        triggerRepeat.minute = time.m
        
        for (i,day) in repeatDays.enumerated(){
            if day{
                if (0...5).contains(i){
                    triggerRepeat.weekday = i + 2
                }
                else if i == 6{
                    triggerRepeat.weekday = 1
                }
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                notificationCenter.add(request)
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
          switch response.actionIdentifier {
          case notificationAction.snooze.rawValue:
            
            let content = UNMutableNotificationContent()
            content.title = response.notification.request.content.title
            content.body = response.notification.request.content.body
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = notificationCategory.snoozable.rawValue

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            notificationCenter.add(request)
            
             break
        
          default:
             break
          }
          completionHandler()
    }
}

enum notificationCategory : String{
    case snoozable = "SNOOZABLE"
}

enum notificationAction : String{
    case snooze = "SNOOZE_ACTION"
}
