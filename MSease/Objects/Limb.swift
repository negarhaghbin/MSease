//
//  Limb.swift
//  MSease
//
//  Created by Negar on 2021-03-10.
//

var limbs : [Limb] = []

enum limb : String{
    case abdomen = "Abdomen"
    case leftThigh = "Left Thigh"
    case rightThigh = "Right Thigh"
    case leftArm = "Left Arm"
    case rightArm = "Right Arm"
    case leftButtock = "Left Buttock"
    case rightButtock = "Right Buttock"
}

class Limb{
    var name : String = ""
    var imageName : String = ""
    var numberOfRows = 0
    var numberOfCols = 0
    
    var hiddenCells : [(x: Int, y: Int)] = []
    
    convenience init(name: String, imageName: String, numberOfRows: Int, numberOfCols: Int, hiddenCells: [(x: Int, y: Int)]) {
        self.init()
        self.name = name
        self.imageName = imageName
        self.numberOfRows = numberOfRows
        self.numberOfCols = numberOfCols
        self.hiddenCells = hiddenCells
    }
    
    func add(){
        limbs.append(self)
    }
    
    static func getLimb(name: String)->Limb{
        for limb in limbs{
            if limb.name == name{
                return limb
            }
        }
        return Limb()
    }
        
    static func initTable(){
        Limb(name: limb.abdomen.rawValue, imageName: "abdomen",
             numberOfRows: 6, numberOfCols: 15,
             hiddenCells: [(0,0), (1,0), (0,14), (1,14), (2,6), (3,6), (2,7), (3,7), (2,8), (3,8)]).add()
        
        Limb(name: limb.leftThigh.rawValue, imageName: "leftThigh",
             numberOfRows: 7, numberOfCols: 5,
             hiddenCells: [(6,0), (6,4)]).add()
        
        Limb(name: limb.rightThigh.rawValue, imageName: "rightThigh",
             numberOfRows: 7, numberOfCols: 5,
             hiddenCells: [(6,0), (6,4)]).add()
        
        Limb(name: limb.leftArm.rawValue, imageName: "leftArm",
             numberOfRows: 6, numberOfCols: 3,
             hiddenCells: []).add()
        
        Limb(name: limb.rightArm.rawValue, imageName: "rightArm",
             numberOfRows: 6, numberOfCols: 3,
             hiddenCells: []).add()
        
        Limb(name: limb.leftButtock.rawValue, imageName: "leftButt",
             numberOfRows: 6, numberOfCols: 4,
             hiddenCells: [(0,3), (3,0), (4,0), (5,0), (4,1), (5,1), (5,2)]).add()
        
        Limb(name: limb.rightButtock.rawValue, imageName: "rightButt",
             numberOfRows: 6, numberOfCols: 4,
             hiddenCells: [(0,0), (5,1), (4,2), (5,2), (3,3), (4,3), (5,3)]).add()
    }
}
