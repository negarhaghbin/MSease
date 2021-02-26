//
//  GridData.swift
//  MSease
//
//  Created by Negar on 2021-02-25.
//

protocol SelectedLimbDelegateProtocol {
    func selectedLimb(newLimb: limb)
}

enum limb{
    case abdomen
    case leftThigh
    case rightThigh
    case leftArm
    case rightArm
    case leftButtock
    case rightButtock
}

struct LimbGridSize {
    static let thigh = (row: 7, col: 5)
    static let arm = (row: 6, col: 3)
    static let buttock = (row: 6, col: 4)
    
    static func gridSize() -> (row: Int, col: Int){
        let row = max(
            LimbGridSize.thigh.row,
            LimbGridSize.arm.row,
            LimbGridSize.buttock.row)
        let col = max(LimbGridSize.thigh.col,
                      LimbGridSize.arm.col,
                      LimbGridSize.buttock.col)
        return (row, col)
    }
}
