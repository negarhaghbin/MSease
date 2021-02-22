//
//  AddNewReminderViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-16.
//

import UIKit

class AddNewReminderViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet var days: Array<UITableViewCell>?
    
    var reminder : Reminder?
    var repeatDays : [Bool] = []
    
    var repeatValue : String = "" //TODO: should be from db
    
    let daysOfTheWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
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
//        timeLabel.text = Date().getTime()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        repeatLabel.text = repeatValue
        for cell in days!{
            if cell.accessoryType == .checkmark{
                repeatDays.append(true)
            }
            else{
                repeatDays.append(false)
            }
        }
    }
    
    func AnimateTableCell(indexPath: IndexPath){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates()
        })
    }
    
    func setRepeatLabel(){
        repeatValue = ""
        var counter = 0
        for (i,day) in repeatDays.enumerated(){
            if day == true{
                repeatValue += "\(daysOfTheWeek[i]), "
                counter += 1
            }
        }
        if counter == 0{
            repeatValue = "None"
        }
        else if counter == 7{
            repeatValue = "Daily"
        }
        else{
            repeatValue.remove(at: repeatValue.index(before: repeatValue.endIndex))
            repeatValue.remove(at: repeatValue.index(before: repeatValue.endIndex))
        }
        
        repeatLabel.text = repeatValue

    }
    
    // MARK: - Actions
    
    @IBAction func addReminder(_ sender: Any) {
        reminder = Reminder(name: nameLabel.text ?? "",
                            mon: repeatDays[0],
                            tue: repeatDays[1],
                            wed: repeatDays[2],
                            thu: repeatDays[3],
                            fri: repeatDays[4],
                            sat: repeatDays[5],
                            sun: repeatDays[6],
                            time: timeLabel.text!,
                            message: textView.text)
        
        RealmManager.shared.addRemidner(newReminder: reminder!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIDatePickerView
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
//        print(sender.date)
        timeLabel.text = sender.date.getTime()
    }
    
    // MARK: - Text Field
    
    @IBAction func textFieldChanged(_ sender: Any) {
        nameLabel.text = nameTextField.text
    }
    
    
    // MARK: - Text View
    
    func textViewDidChange(_ textView: UITextView) {
        messageLabel.text = "Customized"
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
                        
        default:
            print("unknown row")
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

