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
    
    func getTimeInDay()->String{
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: self)
//        let minutes = calendar.component(.minute, from: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
//        return "\(self.):\(minutes) \(formatter.string(from: self))"
    }
    
    func getMonth()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
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
    
    /// returns the start of a date and the end of the date
    func getWholeDate() -> (startDate:Date, endDate: Date) {
        var startDate = self
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate = startDate.addingTimeInterval(length)
        return (startDate,endDate)
    }
}

func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
    let beginDate = from.advanced(by: TimeInterval(-4*60*60))
    var endDate = to.setTime(h: 00, m: 00)
    endDate = endDate.advanced(by: TimeInterval(-4*60*60))
    return dateRange(begin: beginDate, end: endDate).count
}

func getDateFromString(_ dateString:String, style: DateFormatter.Style = .medium)->Date{
    let formatter = DateFormatter()
    formatter.dateStyle = style
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
        if hourInt != 12{
            hourInt += 12
        }
    }
    if ampm == "AM"{
        if hourInt == 12{
            hourInt -= 12
        }
//        else{
//            hourInt -= 1 
//        }
    }
    
//    var dateComponents = Calendar.current.dateComponents([.minute, .hour], from: Date())
//    dateComponents.minute = Int(minute)!
//    dateComponents.hour = hourInt
//
//    return Calendar.current.date(from: dateComponents)!
    return (h: hourInt, m:Int(minute)!)
}

func getTimeFromTimeInDayString(_ time: String)->(h: Int, m:Int){
    var index = time.firstIndex(of: ":")!
    let hour = Int(time[..<index])!
    index = time.index(after: index)
    let minute = Int(time[index...])!
    return (h: hour, m: minute)
}

func convertToAMPM(oldTime: String)->String{
    var index = oldTime.firstIndex(of: ":")!
    var hour = Int(oldTime[..<index])!
    index = oldTime.index(after: index)
    let minute = oldTime[index...]
    var result = ""
    
    if hour < 12{
        result = "\(hour):\(minute) AM"
        if hour == 0{
            result = "12:\(minute) AM"
        }
    }
    else{
        if hour != 12{
            hour -= 12
        }
        result = "\(hour):\(minute) PM"
    }
    
    return result
}



func timeIntervalToPeriodOfTime(timeInterval: TimeInterval)->(days: Double, weeks: Double){
    let minutes = timeInterval / 60.0
    let hours = minutes / 60.0
    let days = hours / 24.0
    let weeks = days / 7.0
    return (days: days, weeks: weeks)
}

func dateRange(begin: Date, end: Date)->[Date]{
    var date = begin
    var result : [Date] = []
    while date <= end {
        result.append(date)
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    return result
}


