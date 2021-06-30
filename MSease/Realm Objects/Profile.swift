//
//  Profile.swift
//  MSease
//
//  Created by Negar on 2021-06-29.
//

import RealmSwift

class Profile: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    @objc dynamic var name: String = ""
    @objc dynamic var profilePicture: Data? = nil
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
    
    convenience init(email: String){
        self.init()
        self._partition = RealmManager.shared.getPartitionValue()
        self.name = email
    }
    
    func getPretestData()->(gender: String, birthday: String, typeOfMS: String, diagnosisDate: String, treatmentBeginningDate: String){
        return (gender: gender, birthday: birthday, typeOfMS: typeOfMS, diagnosisDate: diagnosisDate, treatmentBeginningDate: treatmentBeginningDate)
    }
}

