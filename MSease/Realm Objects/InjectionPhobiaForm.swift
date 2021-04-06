//
//  InjectionPhobiaForm.swift
//  MSease
//
//  Created by Negar on 2021-04-06.
//

import RealmSwift

class InjectionPhobiaForm: Object{
    @objc dynamic var q1 : String = ""
    @objc dynamic var q2 : String = ""
    @objc dynamic var q3 : String = ""
    @objc dynamic var q4 : String = ""
    @objc dynamic var q5 : String = ""
    @objc dynamic var q6 : String = ""
    @objc dynamic var q7 : String = ""
    @objc dynamic var q8 : String = ""
    
    @objc dynamic var date : String = ""
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    convenience init(q1: String, q2: String, q3: String, q4: String, q5: String, q6: String, q7: String, q8: String, partition: String){
        self.init()
        self.q1 = q1
        self.q2 = q2
        self.q3 = q3
        self.q4 = q4
        self.q5 = q5
        self.q6 = q6
        self.q7 = q7
        self.q8 = q8
        self.date = Date().getUSFormat()
        self._partition = partition
    }
    
    override static func primaryKey() -> String{
        return "_id"
    }
    
    func getAnswersFromFields()->[String]{
        return [q1, q2, q3, q4, q5, q6, q7, q8]
    }
    
    
}

