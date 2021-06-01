//
//  File.swift
//  MSease
//
//  Created by Negar on 2021-05-31.
//

import Foundation
import RealmSwift

class Image: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var image: Data? = nil
    @objc dynamic var imageURL: String = ""
    @objc dynamic var referencingNoteID: String = ""
    @objc dynamic var thumbNail: Data? = nil
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(image: Data, thumbNail: Data){
        self.init()
        print("*****")
        print(image)
        self.image = image
        self.thumbNail = thumbNail
        self.imageURL = "https://msease.s3.amazonaws.com/\(_id)"
//        self.referencingNoteID = referencingNoteID
        self._partition = RealmManager.shared.getPartitionValue()
    }
}
