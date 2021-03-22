//
//  Pair.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

import RealmSwift

class Pair: EmbeddedObject{
    @objc dynamic var x = 0
    @objc dynamic var y = 0
    @objc dynamic var partition : String? = nil
    
    convenience init(_ x: Int, _ y: Int){
        self.init()
        self.x = x
        self.y = y
    }
}
