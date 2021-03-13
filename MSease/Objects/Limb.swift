//
//  Limb.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

import RealmSwift

enum limb : String{
    case abdomen = "Abdomen"
    case leftThigh = "Left Thigh"
    case rightThigh = "Right Thigh"
    case leftArm = "Left Arm"
    case rightArm = "Right Arm"
    case leftButtock = "Left Buttock"
    case rightButtock = "Right Buttock"
}

class Limb: Object{
    @objc dynamic var name : String?
    @objc dynamic var numberOfRows = 0
    @objc dynamic var numberOfCols = 0
    
    var hiddenCells : List<Pair> = List()
    
    convenience init(name: String, numberOfRows: Int, numberOfCols: Int, hiddenCells: [Pair]) {
        self.init()
        self.name = name
        self.numberOfRows = numberOfRows
        self.numberOfCols = numberOfCols
        self.hiddenCells.append(objectsIn: hiddenCells)
    }
    

    override static func primaryKey() -> String{
        return "name"
    }
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    class func initTable(){
        Limb(name: limb.abdomen.rawValue,
             numberOfRows: 6, numberOfCols: 15,
             hiddenCells: [Pair(0,0), Pair(1,0), Pair(0,14), Pair(1,14), Pair(2,6), Pair(3,6), Pair(2,7), Pair(3,7), Pair(2,8), Pair(3,8)]).add()
        
        Limb(name: limb.leftThigh.rawValue,
             numberOfRows: 7, numberOfCols: 5,
             hiddenCells: [Pair(6,0), Pair(6,4)]).add()
        
        Limb(name: limb.rightThigh.rawValue,
             numberOfRows: 7, numberOfCols: 5,
             hiddenCells: [Pair(6,0), Pair(6,4)]).add()
        
        Limb(name: limb.leftArm.rawValue,
             numberOfRows: 6, numberOfCols: 3,
             hiddenCells: []).add()
        
        Limb(name: limb.rightArm.rawValue,
             numberOfRows: 6, numberOfCols: 3,
             hiddenCells: []).add()
        
        Limb(name: limb.leftButtock.rawValue,
             numberOfRows: 6, numberOfCols: 4,
             hiddenCells: [Pair(0,3), Pair(3,0), Pair(4,0), Pair(5,0), Pair(4,1), Pair(5,1), Pair(5,2)]).add()
        
        Limb(name: limb.rightButtock.rawValue,
             numberOfRows: 6, numberOfCols: 4,
             hiddenCells: [Pair(0,0), Pair(5,1), Pair(4,2), Pair(5,2), Pair(3,3), Pair(4,3), Pair(5,3)]).add()
    }
}
