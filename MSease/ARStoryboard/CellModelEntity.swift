//
//  CellModelEntity.swift
//  MSease
//
//  Created by Negar on 2021-04-22.
//



// FIXME: Not showing grid when initializing with this class
import Foundation
import RealityKit
import UIKit

class CellModelEntity: Entity, HasModel, HasCollision{
    
    required init(color: UIColor) {
        super.init()
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateBox(width: 0.03, height: 0.002, depth: 0.03),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
        self.generateCollisionShapes(recursive: true)
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
