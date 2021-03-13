//
//  Pair.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

import RealmSwift

class Pair: Object{
    @objc dynamic var x = 0
    @objc dynamic var y = 0
    
//    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(_ x: Int, _ y: Int){
        self.init()
        self.x = x
        self.y = y
    }
    
//    override static func primaryKey() -> String{
//        return "_id"
//    }
}
