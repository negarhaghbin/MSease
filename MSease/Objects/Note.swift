//
//  Note.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import RealmSwift

class Note: Object{
    @objc dynamic var textContent = ""
//    @objc dynamic var date : Date = Date()
    @objc dynamic var date : String = Date().getUSFormat()
    @objc dynamic var time : String = Date().getTime()
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    var images : List<String> = List()
    var symptoms : List<Symptom> = List()
    
    convenience init(textContent: String, date: Date?, images: [String], symptoms: [Symptom]){
        self.init()
        self.textContent = textContent
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTime() ?? Date().getTime()
        self.images.append(objectsIn: images)
        self.symptoms.append(objectsIn: symptoms)
//        self.date = date?.getUSFormat() ?? Date().getUSFormat()
//        self.time = date?.getTime() ?? Date().getTime()
    }
    
    func getImages()->[String]{
        return Array(images)
    }
    
    func getSymptoms()->[Symptom]{
        return Array(symptoms)
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
