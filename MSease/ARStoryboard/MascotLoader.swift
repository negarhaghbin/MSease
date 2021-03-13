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
    // MARK: - Loading Mascot
    
    func placeMascot(_ mascot: ModelEntity){
//        let x = Float(location.x)
//        let z = Float(location.y)
//        mascot.position = [x*0.001, 0, -z*0.001]
        
//        mascot.position = [, 0, ]
        self.anchor.addChild(mascot)
    }
    
    
    func loadMascot(at index: Int, loadedHandler: @escaping () -> Void) {
        var cancellable : AnyCancellable? = nil
        isLoading = true
        
        cancellable = ModelEntity
            .loadModelAsync(named: mascotNames[index].0)
            .collect()
            .sink(receiveCompletion: {error in
                print("Error: \(error)")
                cancellable?.cancel()
            }, receiveValue: { [self]entities in
                let entity = entities.first
                entity!.setScale(SIMD3<Float>(mascotNames[index].1, mascotNames[index].1, mascotNames[index].1), relativeTo: self.anchor)
                entity?.generateCollisionShapes(recursive: true)
                arview.installGestures([.all], for: entity!)
                if isShowingMascot(){
                    removeMascot(at: selectedMascotIndex)
                    placeMascot(entity!)
                }
                selectedMascotIndex = index
                
                self.loadedMascot = entity
                self.isLoading = false
                cancellable?.cancel()
            })
        
        loadedHandler()
    }
    
    func isShowingMascot() -> Bool{
        if selectedMascotIndex != -1{
            return true
        }
        else{
            return false
        }
    }
    
    // MARK: Removing Mascot
    func removeMascot(at index: Int) {
        self.anchor.removeChild(loadedMascot!)
        selectedMascotIndex = -1
        loadedMascot = nil
    }
    
}
