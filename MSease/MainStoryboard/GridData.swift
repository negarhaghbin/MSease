//
//  GridData.swift
//  MSease
//
//  Created by Negar on 2021-02-25.
//

protocol SelectedLimbDelegateProtocol {
    func selectedLimb(newLimb: limb)
}

/*enum limb : String{
    case abdomen
    case leftThigh
    case rightThigh
    case leftArm
    case rightArm
    case leftButtock
    case rightButtock
}

struct LimbGridSize {
    static let abdomen = (row: 6, col: 15, hidden:[(0,0), (1,0), (0,14), (1,14), (2,6), (3,6), (2,7), (3,7), (2,8), (3,8)])
    static let thigh = (row: 7, col: 5, hidden:[(6,0), (6,4)])
    static let arm = (row: 6, col: 3)
    static let leftButtock = (row: 6, col: 4, hidden:[(0,3), (3,0), (4,0), (5,0), (4,1), (5,1), (5,2)])
    static let rightButtock = (row: 6, col: 4, hidden:[(0,0), (5,1), (4,2), (5,2), (3,3), (4,3), (5,3)])
    
    static func gridSize() -> (row: Int, col: Int){
        let row = max(
            LimbGridSize.abdomen.row,
            LimbGridSize.thigh.row,
            LimbGridSize.arm.row,
            LimbGridSize.leftButtock.row,
            LimbGridSize.rightButtock.row
        )
        let col = max(
            LimbGridSize.abdomen.col,
            LimbGridSize.thigh.col,
            LimbGridSize.arm.col,
            LimbGridSize.leftButtock.col,
            LimbGridSize.rightButtock.col
        )
        return (row, col)
    }
}*/
