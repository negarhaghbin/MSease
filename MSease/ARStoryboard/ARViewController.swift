//
//  ARViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-25.
//

import UIKit
import RealityKit
import ARKit
import Combine

class ARViewController: UIViewController {
    
    @IBOutlet var arview : ARView!
    
    let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
    let coachingOverlay = ARCoachingOverlayView()
    
    var cards : [[Entity]] = []
    var tappedCards : [[Entity]] = []
    var currentTappedCardIndices : (Int, Int)?
    var selectedLimb : limb?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoachingOverlay()
        arview.scene.addAnchor(anchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createGrid(completionHandler: { hidden in
            placeGrid(hidden: hidden)
            placeMascot()
        })
    }
    
    func createGrid(completionHandler: ([(Int, Int)])->()){
        var row = 0
        var col = 0
        var hidden : [(Int, Int)]?
        switch selectedLimb{
        case .none:
            print("unknown limb")
        case .abdomen:
            row = LimbGridSize.abdomen.row
            col = LimbGridSize.abdomen.col
            hidden = LimbGridSize.abdomen.hidden
            
        case .leftThigh, .rightThigh:
            row = LimbGridSize.thigh.row
            col = LimbGridSize.thigh.col
            hidden = LimbGridSize.thigh.hidden

        case .leftArm, .rightArm:
            row = LimbGridSize.arm.row
            col = LimbGridSize.arm.col
            hidden = []
            
        case .leftButtock:
            row = LimbGridSize.leftButtock.row
            col = LimbGridSize.leftButtock.col
            hidden = LimbGridSize.leftButtock.hidden
            
        case .rightButtock:
            row = LimbGridSize.rightButtock.row
            col = LimbGridSize.rightButtock.col
            hidden = LimbGridSize.rightButtock.hidden
        }
        
        for i in 0..<row{
            for _ in 0..<col{
                let box = MeshResource.generateBox(width: 0.03, height: 0.002, depth: 0.03)
                let cellMaterial = SimpleMaterial(color: UIColor(red: 0.32, green: 0.625, blue: 0.746, alpha: 1), isMetallic: false)
                let model = ModelEntity(mesh: box, materials: [cellMaterial])
                
                model.generateCollisionShapes(recursive: true)
                if cards.count-1 < i{
                    cards.append([])
                }
                cards[i].append(model)
                
                let selectedBoxMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
                let selectedModel = ModelEntity(mesh: box, materials: [selectedBoxMaterial])
                selectedModel.generateCollisionShapes(recursive: true)
                if tappedCards.count-1 < i{
                    tappedCards.append([])
                }
                tappedCards[i].append(selectedModel)
                
                /*self.grid2D[i][j] = self.grid![i*LimbGridSize.gridSize().col+j]
                self.grid2D[i][j].isHidden = false*/
            }
        }
        
        
        
        /*for _ in 1...numberOfCells{
            let box = MeshResource.generateBox(width: 0.03, height: 0.002, depth: 0.03)
            let cellMaterial = SimpleMaterial(color: UIColor(red: 0.32, green: 0.625, blue: 0.746, alpha: 1), isMetallic: false)
            let model = ModelEntity(mesh: box, materials: [cellMaterial])
            
            model.generateCollisionShapes(recursive: true)
            cards.append(model)
            
            let selectedBoxMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
            let selectedModel = ModelEntity(mesh: box, materials: [selectedBoxMaterial])
            selectedModel.generateCollisionShapes(recursive: true)
            tappedCards.append(selectedModel)
        }*/
        
        completionHandler(hidden!)
    }
    
    func placeGrid(hidden: [(Int, Int)]){
        for (i,cardRow) in cards.enumerated(){
            for (j, card) in cardRow.enumerated(){
                if hidden.contains(where: {
                    return i==$0 && j == $1
                }){
                    continue
                }
                card.position = [Float(i)*0.045, 0, Float(j)*0.045]
                tappedCards[i][j].position = card.position
                anchor.addChild(card)
            }
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
    
    func indices(of x: Entity, in array:[[Entity]]) -> (Int, Int)? {
        for (i, row) in array.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }
        return nil
    }
    
    func turnLastTappedCell(){
        anchor.addChild(cards[currentTappedCardIndices!.0][currentTappedCardIndices!.1])
        anchor.removeChild(tappedCards[currentTappedCardIndices!.0][currentTappedCardIndices!.1])
    }
    
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arview)
        if let card = arview.entity(at: tapLocation){
            if let indices = indices(of: card, in: cards){
                if currentTappedCardIndices != nil{
                    turnLastTappedCell()
                }
                anchor.addChild(tappedCards[indices.0][indices.1])
                currentTappedCardIndices = indices
                anchor.removeChild(card)
            }
            else if let indices = indices(of: card, in: tappedCards){
                anchor.addChild(cards[indices.0][indices.1])
                anchor.removeChild(card)
                currentTappedCardIndices = nil
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
