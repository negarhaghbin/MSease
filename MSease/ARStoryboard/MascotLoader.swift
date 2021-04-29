//
//  MascotLoader.swift
//  MSease
//
//  Created by Negar on 2021-01-21.
//

import Foundation
import ARKit
import RealityKit
import Combine

extension ARViewController {
    
    func loadMascots() {
        var cancellable : AnyCancellable? = nil
        isLoading = true
        
        cancellable = ModelEntity
            .loadModelAsync(named: mascotNames[0].name)
            .append(ModelEntity
                        .loadModelAsync(named: mascotNames[1].name))
            .append(ModelEntity
                        .loadModelAsync(named: mascotNames[2].name))
            .collect()
            .sink(receiveCompletion: {error in
                print("Error: \(error)")
                cancellable?.cancel()
            }, receiveValue: { [self]entities in
                
                for (index, entity) in entities.enumerated(){
                    entity.setScale(SIMD3<Float>(mascotNames[index].1, mascotNames[index].1, mascotNames[index].1), relativeTo: self.anchor)
                    entity.generateCollisionShapes(recursive: true)
                    loadedMascots.append(entity)
                }
                if isShowingObjects(){
                    if selectedMascotIndex != -1{
                        parentEntity.addChild(loadedMascots[selectedMascotIndex])
                    }
                }
                /*let entity = entities.first
                
                if isShowingMascot(){
                    removeMascot(at: selectedMascotIndex)
                    placeMascot(entity!)
                }
                selectedMascotIndex = index
                
                self.loadedMascot = entity
                self.isLoading = false*/
                
                cancellable?.cancel()
            })
    }
    
    
    /* func isShowingMascot() -> Bool{
        guard let _ = loadedMascot else {
            return false
        }
        return true
    }
    
    func placeMascot(_ mascot: ModelEntity){
        self.parentEntity.addChild(mascot)
    }
    
    func removeMascot(at index: Int) {
        if isShowingMascot(){
            self.anchor.removeChild(loadedMascot!)
            selectedMascotIndex = -1
            loadedMascot = nil
        }
    }*/
    
}
