//
//  ARViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-25.
//

import UIKit
import RealityKit
import Combine

class ARViewController: UIViewController {
    
    @IBOutlet var arview : ARView!
    
    let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
    
    var cards : [Entity] = []
    var tappedCards : [Entity] = []
    var numberOfCells : Int = 0
    var selectedLimb : limb?

    override func viewDidLoad() {
        super.viewDidLoad()
        arview.scene.addAnchor(anchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createGrid(completionHandler: {
            placeGrid()
        })
        placeMascot()
    }
    
    func createGrid(completionHandler: ()->()){
        switch selectedLimb{
        case .none:
            print("unknown limb")
        case .abdomen:
            print("TODO")
        case .leftThigh:
            numberOfCells = (LimbGridSize.thigh.row * LimbGridSize.thigh.col) - 2 //the hidden ones
        case .rightThigh:
            print("TODO")
        case .leftArm:
            print("TODO")
        case .rightArm:
            print("TODO")
        case .leftButtock:
            print("TODO")
        case .rightButtock:
            print("TODO")
        }
        for _ in 1...numberOfCells{
            let box = MeshResource.generateBox(width: 0.03, height: 0.002, depth: 0.03)
            let cellMaterial = SimpleMaterial(color: UIColor(red: 0.32, green: 0.625, blue: 0.746, alpha: 1), isMetallic: false)
            let model = ModelEntity(mesh: box, materials: [cellMaterial])
            
            model.generateCollisionShapes(recursive: true)
            cards.append(model)
            
            let selectedBoxMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
            let selectedModel = ModelEntity(mesh: box, materials: [selectedBoxMaterial])
            selectedModel.generateCollisionShapes(recursive: true)
            tappedCards.append(selectedModel)
        }
        
        completionHandler()
    }
    
    func placeGrid(){
        for (index, card) in cards.enumerated(){
            var x : Float?
            var z : Float?
            
            switch selectedLimb{
            case .none:
                print("unknown limb")
            case .abdomen:
                print("TODO")
            case .leftThigh:
                if index > cards.count-4{
                    x = Float((index+1) % LimbGridSize.thigh.col)
                    z = Float((index+1) / LimbGridSize.thigh.row)
                }
                else{
                    x = Float(index % LimbGridSize.thigh.col)
                    z = Float(index / LimbGridSize.thigh.row)
                }
            case .rightThigh:
                print("TODO")
            case .leftArm:
                print("TODO")
            case .rightArm:
                print("TODO")
            case .leftButtock:
                print("TODO")
            case .rightButtock:
                print("TODO")
            }
            card.position = [x!*0.045, 0, z!*0.045]
            tappedCards[index].position = card.position
            
            anchor.addChild(card)
        }
    }
    
    func placeMascot(){
        var cancellable : AnyCancellable? = nil
        
//        cancellable = ModelEntity.loadModelAsync(named: "toy_biplane")
        cancellable = ModelEntity.loadModelAsync(named: "toy_drummer")
            .collect().sink(receiveCompletion: {error in
                print("Error: \(error)")
                cancellable?.cancel()
            }, receiveValue: {entities in
                var objects : [ModelEntity] = []
                for entity in entities{
                    entity.setScale(SIMD3<Float>(0.009, 0.009, 0.009), relativeTo: self.anchor)
                    entity.generateCollisionShapes(recursive: true)
                    objects.append(entity.clone(recursive: true))
                }
                objects.shuffle()
                
                let x = Float(0.5)
                let z = Float(4)
                
                objects[0].position = [x*0.045, 0, -z*0.022]
                self.anchor.addChild(objects[0])
//                for (index, object) in objects.enumerated(){
//                    self.cards[index].addChild(object)
//                }
                cancellable?.cancel()
            })
    }
    
    func turnOtherSelectedCells(){
        for tappedCard in tappedCards{
            if anchor.children.contains(tappedCard){
                anchor.addChild(cards[tappedCards.firstIndex(of: tappedCard)!])
                anchor.removeChild(tappedCard)
                break
            }
        }
    }
    
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arview)
        if let card = arview.entity(at: tapLocation){
            if cards.contains(card){
                turnOtherSelectedCells()
                anchor.addChild(tappedCards[cards.firstIndex(of: card)!])
                anchor.removeChild(card)
            }
            else if tappedCards.contains(card){
                anchor.addChild(cards[tappedCards.firstIndex(of: card)!])
                anchor.removeChild(card)
            }
            else{
                print("unknown object tapped")
            }
//            if card.transform.rotation.angle == .pi{
//                var flipDownTransform = card.transform
//                flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
//                card.move(to: flipDownTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
//            }
//            else{
//                var flipUpTransform = card.transform
//                flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
//                card.move(to: flipUpTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
//            }
            
            
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ARViewController : SelectedLimbDelegateProtocol{
    func selectedLimb(newLimb: limb) {
        self.selectedLimb = newLimb
    }
    
}
