//
//  Note.swift
//  MSease
//
//  Created by Negar on 2021-02-12.
//

import RealmSwift

class Note: Object{
    @objc dynamic var textContent = ""
    @objc dynamic var date : String = "" //Date().getUSFormat()
    @objc dynamic var time : String = "" //Date().getTime()
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    var images : List<String> = List()
    var symptomNames : List<String> = List()
    
    convenience init(textContent: String, date: Date?, images: [String], symptoms: [String], partition: String){
        self.init()
        self.textContent = textContent
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTime() ?? Date().getTime()
        self.images.append(objectsIn: images)
        self.symptomNames.append(objectsIn: symptoms)
        self._partition = partition
    }
    
    func getImages()->[String]{
        return Array(images)
    }
    
    func getSymptoms()->[String]{
        return Array(symptomNames)
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
