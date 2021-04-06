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
        return formatter.string(from: self)
//        return "\(self.):\(minutes) \(formatter.string(from: self))"
    }
    
    func setTime(h: Int, m: Int)->Date{
        var hour = h
        if h == 24{
            hour -= 12
        }
        var date = Calendar.current.date(bySetting: .hour, value: hour, of: self)!
        date = Calendar.current.date(bySetting: .minute, value: m, of: date)!
        return date
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
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

func getDateFromString(_ dateString:String)->Date{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "en_US")
    return formatter.date(from: dateString)!
}

func getTimeFromString(_ time: String)->(h: Int, m:Int){
    var index = time.firstIndex(of: ":")!
    let hour = time[..<index]
    index = time.index(after: index)
    let minute = time[index..<time.firstIndex(of: " ")!]
    index = time.firstIndex(of: " ")!
    index = time.index(after: index)
    let ampm = time[index...]
    
    var hourInt = Int(hour)!
    
    if ampm == "PM"{
        hourInt += 12
    }
    
//    var dateComponents = Calendar.current.dateComponents([.minute, .hour], from: Date())
//    dateComponents.minute = Int(minute)!
//    dateComponents.hour = hourInt
//
//    return Calendar.current.date(from: dateComponents)!
    return (h: hourInt, m:Int(minute)!)
}

func timeIntervalToWeeks(timeInterval: TimeInterval)->Double{
    let seconds = timeInterval / 1000.0
    let minutes = seconds / 60.0
    let hours = minutes / 60.0
    let days = hours / 24.0
    let weeks = days / 7.0
    return weeks
}


