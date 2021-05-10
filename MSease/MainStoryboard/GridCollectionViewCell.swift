//
//  GridCollectionViewCell.swift
//  MSease
//
//  Created by Negar on 2021-01-25.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Variables
    var grid2D : [[UIImageView]] = []
    
    // MARK: - Helpers
    func initiate(){
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.minimumScaleFactor = 0.5
        
        let selectedLimb = limbs[self.tag]
        textLabel.text = selectedLimb.name
        bodyImage.image = UIImage(named: selectedLimb.imageName)!
        prepareGrid(limbGrid: selectedLimb)
    }
    
    func hideExtraRowsAndCols(hidden:[(x: Int, y: Int)]){
        for block in hidden{
            self.grid2D[block.x][block.y].isHidden = true
        }
    }
    
    private func removePreviousGrid(){
        grid2D = []
        for imageview in contentView.subviews{
            if let imageview = imageview as? UIImageView{
                if imageview.image == UIImage(systemName: "square.fill"){
                    imageview.removeFromSuperview()
                }
            }
        }
    }
    
    private func createImageView(at point:(i: Int, j: Int), width: Double)->UIImageView{
        let xVal = Double((0.75+Double(point.j))*width - Double(2*point.j))
        let yVal = Double((2.25+Double(point.i))*width - Double(point.i))
        let frame = CGRect(x: xVal, y: yVal, width: width, height: width)
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(systemName: "square.fill")
        imageView.tintColor = UIColor(hex: StylingUtilities.InjectionCodes[StylingUtilities.InjectionCodes.count-1].colorCode)
        return imageView
    }
    
    private func prepareGrid(limbGrid: Limb){
        removePreviousGrid()
        
        let injectionsOnDates = RealmManager.shared.getRecentInjectionsForLimb(limb: limbGrid)
        
        var cells : [(x: Int, y: Int, color: String)] = []
        
        for (i,injections) in injectionsOnDates.enumerated(){
            for injection in injections{
                cells.append((x: injection.selectedCellX, y: injection.selectedCellY, color:StylingUtilities.InjectionCodes[i].colorCode))
            }
            
        }
        
        let width : Double?
        if limbGrid.name == "Abdomen"{
            width = Double(self.frame.width/20)
        }
        else{
            width = Double(self.frame.width/10)
        }
        
        for i in 0..<limbGrid.numberOfRows{
            grid2D.append([])
            for j in 0..<limbGrid.numberOfCols{
                let imageView = createImageView(at:(i: i, j: j), width: width!)
                
                let temp = cells.filter({ pair in
                    return (pair.x == i) && (pair.y == j)
                })
                if temp.count>0{
                    imageView.tintColor = UIColor(hex: temp[0].color)
                }
                
                grid2D[i].append(imageView)
                self.contentView.addSubview(imageView)
            }
        }
        
        hideExtraRowsAndCols(hidden: Array(limbGrid.hiddenCells))
    }
}
