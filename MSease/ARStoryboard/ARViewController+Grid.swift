//
//  ARViewController+Grid.swift
//  MSease
//
//  Created by Negar on 2021-04-29.
//

import UIKit
import RealityKit

extension ARViewController{

    func createGrid(completionHandler: ([(x: Int, y: Int)])->()){
        let limb = Limb.getLimb(name: selectedLimbName!)
        let row = limb.numberOfRows
        let col = limb.numberOfCols
        let hidden : [(x: Int, y: Int)] = Array(limb.hiddenCells)
        
        for i in 0..<row{
            for _ in 0..<col{
                
                let model = CellModelEntity(color: UIColor(hex: StylingUtilities.InjectionCodes[StylingUtilities.InjectionCodes.count-1].colorCode)!)
                if cells.count-1 < i{
                    cells.append([])
                }
                cells[i].append(model)
                
                let selectedModel = CellModelEntity(color: .yellow)
                if tappedCells.count-1 < i{
                    tappedCells.append([])
                }
                tappedCells[i].append(selectedModel)
                
            }
        }
        
        completionHandler(hidden)
    }
    
    func placeGrid(hidden: [(x: Int, y: Int)]){
        
        for (i,cellRow) in cells.enumerated(){
            for (j, cell) in cellRow.enumerated(){
                if hidden.contains(where: { pair in
                    let result = ((pair.x == i) && (pair.y == j))
                    return result
                }){
                    continue
                }
                
                let r = cellRow.count%2 == 0 ? Float(0.5) : Float(0)
                
                cell.position = [(Float(j-cellRow.count/2)+r)*0.035, 0, 0.05 + Float(i)*0.035]
                
                tappedCells[i][j].position = cell.position
                parentEntity.addChild(cell)
            }
        }
    }
    
    func indices(of x: Entity, in array:[[Entity]]) -> (Int, Int)? {
        for (i, row) in array.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }
        return nil
    }
    
    func selectCell(cell: Entity, index: (Int, Int)){
        parentEntity.addChild(tappedCells[index.0][index.1])
        currentTappedCellIndices = index
        parentEntity.removeChild(cell)
    }
    
    func deselectCell(cell: Entity, index: (Int,Int)){
        parentEntity.addChild(cells[index.0][index.1])
        parentEntity.removeChild(cell)
        currentTappedCellIndices = nil
    }

}
