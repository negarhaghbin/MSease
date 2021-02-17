//
//  Note.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import RealmSwift

class Note: Object{
    @objc dynamic var textContent = ""
//    @objc dynamic var imageNames : [String] = []
    @objc dynamic var date : String = Date().getUSFormat()
    @objc dynamic var time : String = Date().getTime()
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(textContent: String, date: Date?){
        self.init()
        self.textContent = textContent
//        self.imageNames = imageNames ?? []
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTime() ?? Date().getTime()
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
