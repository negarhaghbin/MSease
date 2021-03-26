//
//  Reminder.swift
//  MSease
//
//  Created by Negar on 2021-02-16.
//

import RealmSwift

class Reminder: Object{
    @objc dynamic var name = "Reminder"
    @objc dynamic var mon = true
    @objc dynamic var tue = true
    @objc dynamic var wed = true
    @objc dynamic var thu = true
    @objc dynamic var fri = true
    @objc dynamic var sat = true
    @objc dynamic var sun = true
    @objc dynamic var time : String = ""
    @objc dynamic var message : String = "Have you write in your journal today?"
    @objc dynamic var isOn = true
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    convenience init(name: String, mon: Bool, tue: Bool, wed: Bool, thu: Bool, fri: Bool, sat: Bool, sun: Bool, time: String, message: String?, partition: String, isOne : Bool? = true){
        self.init()
        self.name = name
        self.mon = mon
        self.tue = tue
        self.wed = wed
        self.thu = thu
        self.fri = fri
        self.sat = sat
        self.sun = sun
        self.time = time
        self.message = message ?? "Have you write in your journal today?"
        self._partition = partition
    }
    
    func getRepeatDaysList()->[Bool]{
        var result : [Bool] = []
        result.append(mon)
        result.append(tue)
        result.append(wed)
        result.append(thu)
        result.append(fri)
        result.append(sat)
        result.append(sun)
        
        return result
    }
    
    func getRepeatationDays()->String{
        let repeatDays = getRepeatDaysList()
        var repeatValue = ""
        var counter = 0
        
        for (i,day) in repeatDays.enumerated(){
            if day == true{
                repeatValue += "\(daysOfTheWeek[i]), "
                counter += 1
            }
        }
        if counter == 7{
            repeatValue = "Daily"
        }
        else{
            repeatValue.remove(at: repeatValue.index(before: repeatValue.endIndex))
            repeatValue.remove(at: repeatValue.index(before: repeatValue.endIndex))
        }
        
        return repeatValue
    }
    
    func setId(id:ObjectId){
        self._id = id
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
