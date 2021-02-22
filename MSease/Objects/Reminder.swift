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
    @objc dynamic var time : String = Date().getTime()
    @objc dynamic var message : String = "Have you write in your journal today?"
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(name: String, mon: Bool, tue: Bool, wed: Bool, thu: Bool, fri: Bool, sat: Bool, sun: Bool, time: String, message: String?){
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
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
