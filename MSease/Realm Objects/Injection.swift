//
//  Injection.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

import RealmSwift

class Injection: Object{
    @objc dynamic var limbName : String = ""
    @objc dynamic var selectedCellX = 0
    @objc dynamic var selectedCellY = 0
    @objc dynamic var date : String = Date().getUSFormat()
    @objc dynamic var time : String = Date().getTime()
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    convenience init(limbName: String, selectedCellX: Int, selectedCellY: Int, date: Date?){
        self.init()
        self.limbName = limbName
        self.selectedCellX = selectedCellX
        self.selectedCellY = selectedCellY
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTime() ?? Date().getTime()
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
