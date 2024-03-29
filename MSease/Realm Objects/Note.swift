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
    
    var imageURLs : List<String> = List()
    var symptomNames : List<String> = List()
    
    convenience init(textContent: String, date: Date?, imageURLs: [String], symptoms: [String], partition: String, hasBucket: Bool = true){
        self.init()
        if hasBucket{
            app.currentUser?.functions.createNoteBucket([AnyBSON(_id.stringValue)])
        }
        
        self.textContent = textContent
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTimeInDay() ?? Date().getTimeInDay()
        self.imageURLs.append(objectsIn: imageURLs)
        self.symptomNames.append(objectsIn: symptoms)
        self._partition = partition
        
    }
    
    func getImageNames()->[String]{
        return Array(imageURLs)
    }
    
    func getSymptoms()->[String]{
        return Array(symptomNames)
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
