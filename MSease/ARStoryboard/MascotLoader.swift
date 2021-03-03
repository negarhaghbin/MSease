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
        let x = Float(0.5)
        let z = Float(4)
        mascot.position = [x*0.045, 0, -z*0.022]
        self.anchor.addChild(mascot)
    }
    
    
    func loadMascot(at index: Int, loadedHandler: @escaping () -> Void) {
        var cancellable : AnyCancellable? = nil
        isLoading = true
        cancellable = ModelEntity
            .loadModelAsync(named: mascotNames[index])
            .collect()
            .sink(receiveCompletion: {error in
                print("Error: \(error)")
                cancellable?.cancel()
            }, receiveValue: {entities in
                let entity = entities.first
                entity!.setScale(SIMD3<Float>(0.009, 0.009, 0.009), relativeTo: self.anchor)
                self.loadedMascot = entity
                self.addMascotButton.isHidden = true
                self.isLoading = false
                cancellable?.cancel()
            })
        
        loadedHandler()
    }
    
    // MARK: - Removing Mascot
    func removeMascot(at index: Int) {
        self.anchor.removeChild(loadedMascot!)
        selectedMascotIndex = -1
        loadedMascot = nil
    }
}
