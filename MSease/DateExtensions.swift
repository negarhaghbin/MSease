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
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: self)
//        let minutes = calendar.component(.minute, from: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return "\(formatter.string(from: self))"
//        return "\(self.):\(minutes) \(formatter.string(from: self))"
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
