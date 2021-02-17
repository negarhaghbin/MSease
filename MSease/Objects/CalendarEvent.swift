//
//  CalendarEvent.swift
//  MSease
//
//  Created by Negar on 2021-02-15.
//

import RealmSwift

class CalendarEvent: Object{
    @objc dynamic var date : String = Date().getUSFormat()
    @objc dynamic var journalItem : Note? = Note()
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(date: Date, journalItem: Note){
        self.init()
        self.date = date.getUSFormat()
        self.journalItem = journalItem
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
