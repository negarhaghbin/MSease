//
//  Injection.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

import RealmSwift

class Injection: Object{
    @objc dynamic var limb : Limb?
    @objc dynamic var selectedCell : Pair?
    @objc dynamic var date : String = Date().getUSFormat()
    @objc dynamic var time : String = Date().getTime()
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(limb: Limb, selectedCell: Pair, date: Date?){
        self.init()
        self.limb = limb
        self.selectedCell = selectedCell
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTime() ?? Date().getTime()
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
    
}
