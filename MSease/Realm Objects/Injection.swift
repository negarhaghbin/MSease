//
//  Injection.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

import RealmSwift

class Injection: Object{
    @objc dynamic var limbName : String = ""
    @objc dynamic var selectedCellX : Int = 0
    @objc dynamic var selectedCellY : Int = 0
    @objc dynamic var date : String = ""
    @objc dynamic var time : String = ""
    @objc dynamic var painScale : Int = 0
    @objc dynamic var note : String = ""
    @objc dynamic var hasUsedAR : Bool = true
    
    var symptomNames : List<String> = List()
    var reactionNames : List<String> = List()
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    convenience init(limbName: String, selectedCellX: Int, selectedCellY: Int, hasUsedAR: Bool? = true, date: Date?, partition: String){
        self.init()
        self.limbName = limbName
        self.selectedCellX = selectedCellX
        self.selectedCellY = selectedCellY
        self.hasUsedAR = hasUsedAR!
        self.date = date?.getUSFormat() ?? Date().getUSFormat()
        self.time = date?.getTimeInDay() ?? Date().getTimeInDay()
        self._partition = partition
    }
    
    func getReactions()->[String]{
        return Array(reactionNames)
    }
    
    func getSymptoms()->[String]{
        return Array(symptomNames)
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
}
