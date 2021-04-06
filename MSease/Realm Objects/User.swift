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
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
