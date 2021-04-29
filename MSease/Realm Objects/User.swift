//
//  User.swift
//  MSease
//
//  Created by Negar on 2021-03-12.
//

import RealmSwift

class User: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var hasSignedConsent: Bool = false
    
    @objc dynamic var gender: String = ""
    @objc dynamic var birthday: String = ""
    @objc dynamic var typeOfMS: String = ""
    @objc dynamic var diagnosisDate: String = ""
    @objc dynamic var treatmentBeginningDate: String = ""
    
    @objc dynamic var mascot: String = "Drummer"
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    func getPretestData()->(gender: String, birthday: String, typeOfMS: String, diagnosisDate: String, treatmentBeginningDate: String){
        return (gender: gender, birthday: birthday, typeOfMS: typeOfMS, diagnosisDate: diagnosisDate, treatmentBeginningDate: treatmentBeginningDate)
    }
}
