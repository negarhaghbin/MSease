//
//  AddNewReminderViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-16.
//

import UIKit

class AddNewReminderViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet var days: Array<UITableViewCell>?
    
    var reminder : Reminder?
    
    enum daysOfTheWeek : Int{
        case mon = 0
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func AnimateTableCell(indexPath: IndexPath){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
    
    // MARK: - Actions
    
    @IBAction func addReminder(_ sender: Any) {
        var repeatDays : [Bool] = []
        
        for cell in days!{
            if cell.accessoryType == .checkmark{
                repeatDays.append(true)
            }
            else{
                repeatDays.append(false)
            }
        }
        
        reminder = Reminder(name: nameLabel.text ?? "",
                            mon: repeatDays[daysOfTheWeek.mon.rawValue],
                            tue: repeatDays[daysOfTheWeek.tue.rawValue],
                            wed: repeatDays[daysOfTheWeek.wed.rawValue],
                            thu: repeatDays[daysOfTheWeek.thu.rawValue],
                            fri: repeatDays[daysOfTheWeek.fri.rawValue],
                            sat: repeatDays[daysOfTheWeek.sat.rawValue],
                            sun: repeatDays[daysOfTheWeek.sun.rawValue],
                            time: timePicker.date,
                            message: textView.text)
        
        RealmManager.shared.addRemidner(newReminder: reminder!)
    }
    
    // MARK: - Text Field
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        nameLabel.text = textField.text
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case rows.time.rawValue:
            timePicker.isHidden = !timePicker.isHidden
            
        case rows.message.rawValue:
            textView.isHidden = !textView.isHidden
            
        case rows.repeatRow.rawValue:
            for cell in days!{
                cell.isHidden = !cell.isHidden
            }
            
        case rows.name.rawValue:
            nameTextField.isHidden = !nameTextField.isHidden
            nameLabel.text = nameTextField.text
                        
        default:
            print("unknown row")
        }
        AnimateTableCell(indexPath: indexPath)
        
        if (rows.mon.rawValue...rows.sun.rawValue).contains(indexPath.row){
            let cell = days![indexPath.row-rows.mon.rawValue]
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
        }
        
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

