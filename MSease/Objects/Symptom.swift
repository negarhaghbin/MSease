//
//  Symptom.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import RealmSwift

class Symptom: Object{
    @objc dynamic var name = ""
    @objc dynamic var imageName = ""
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(name: String, imageName: String){
        self.init()
        self.name = name
        self.imageName = imageName
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
