//
//  DateExtensions.swift
//  MSease
//
//  Created by Negar on 2021-01-27.
//

import Foundation

extension Date{
    func getUSFormat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func getTime()->String{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "a"

        return "\(hour):\(minutes) \(formatter.string(from: Date()))"
    }
    
    func printFullTime(){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let date = calendar.date(bySettingHour: hour, minute: minutes, second: 0, of: self)!
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a, d MMM y"
        print(formatter.string(from: date))
    }
}
