//
//  GridCollectionViewController.swift
//  ARKitInteraction
//
//  Created by Negar on 2021-01-25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

private let sectionInsets = UIEdgeInsets(top: 5.0, left: 4.0, bottom: 5.0, right: 4.0)
var cgsize : CGSize? = nil

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var grid: Array<UIImageView>?
    
    var grid2D : [[UIImageView]] = Array(repeating: Array(repeating: UIImageView(), count: LimbGridSize.gridSize().col), count: LimbGridSize.gridSize().row)
    
    func setCellValues(title: String, imageName: String){
        self.textLabel.text = title
        self.bodyImage.image = imageWithImage(image: UIImage(named: imageName)!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
    }
    
    func initiate(){
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.minimumScaleFactor = 0.5
        create2DGridFrom1D()
    }
    
    func hideExtraRowsAndCols(row: Int, col: Int, hidden:[(Int, Int)]){
        for i in row..<LimbGridSize.gridSize().row{
            for j in 0..<LimbGridSize.gridSize().col{
                self.grid2D[i][j].isHidden = true
            }
        }
        for i in col..<LimbGridSize.gridSize().col{
            for j in 0..<LimbGridSize.gridSize().row{
                self.grid2D[j][i].isHidden = true
            }
        }
        for block in hidden{
            self.grid2D[block.0][block.1].isHidden = true
        }
    }
    
    func create2DGridFrom1D(){
        self.grid = self.grid!.sorted { $0.tag < $1.tag }
        for i in 0..<LimbGridSize.gridSize().row{
            for j in 0..<LimbGridSize.gridSize().col{
                self.grid2D[i][j] = self.grid![i*LimbGridSize.gridSize().col+j]
                self.grid2D[i][j].isHidden = false
            }
        }
    }
    
}

class GridCollectionViewController: UICollectionViewController {
    private let GridRectViewCellIdentifier = "GridRectViewCell"
    private let GridSquareViewCellIdentifier = "GridSquareViewCell"
    
    var selectedLimb : limb?
//    var delegate : SelectedLimbDelegateProtocol? = nil
    
    enum gridSections : Int {
        case abdomen = 0
        case notAbdomen = 1
    }
    
    enum gridNotAbdomenSectionItems : Int, CaseIterable{
        case leftThigh = 0
        case rightThigh = 1
        case leftArm = 2
        case rightArm = 3
        case leftButtock = 4
        case rightButtock = 5
    }

    private var itemsPerRow: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func prepareGrid(cell: GridCollectionViewCell, indexPath: IndexPath){
        if indexPath.section == gridSections.abdomen.rawValue{
            //TODO
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                cell.hideExtraRowsAndCols(row: LimbGridSize.thigh.row, col:LimbGridSize.thigh.col, hidden: LimbGridSize.thigh.hidden)
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                cell.hideExtraRowsAndCols(row: LimbGridSize.thigh.row, col:LimbGridSize.thigh.col, hidden: LimbGridSize.thigh.hidden)
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                cell.hideExtraRowsAndCols(row: LimbGridSize.arm.row, col:LimbGridSize.arm.col, hidden: [])
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                cell.hideExtraRowsAndCols(row: LimbGridSize.arm.row, col:LimbGridSize.arm.col, hidden: [])
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                cell.hideExtraRowsAndCols(row: LimbGridSize.leftButtock.row, col:LimbGridSize.leftButtock.col, hidden: LimbGridSize.leftButtock.hidden)
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                cell.hideExtraRowsAndCols(row: LimbGridSize.rightButtock.row, col:LimbGridSize.rightButtock.col, hidden: LimbGridSize.rightButtock.hidden)
            default:
                print("unknown limb")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == gridSections.abdomen.rawValue{
            selectedLimb = limb.abdomen
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                selectedLimb = limb.leftArm
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                selectedLimb = limb.rightArm
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                selectedLimb = limb.leftThigh
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                selectedLimb = limb.rightThigh
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                selectedLimb = limb.leftButtock
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                selectedLimb = limb.rightButtock
            default:
                print("unknown limb")
            }
            
        }
        
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ARVC") as! ARViewController
        vc.selectedLimb = selectedLimb
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return gridNotAbdomenSectionItems.allCases.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> GridCollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridSquareViewCellIdentifier, for: indexPath) as! GridCollectionViewCell
        
        cell.initiate()
        
        if indexPath.section == gridSections.abdomen.rawValue{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridRectViewCellIdentifier, for: indexPath) as! GridCollectionViewCell
            
            cell.setCellValues(title: "Abdomen", imageName: "abdomen")
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                cell.setCellValues(title: "Left Thigh", imageName: "leftThigh")
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                cell.setCellValues(title: "Right Thigh", imageName: "rightThigh")
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                cell.setCellValues(title: "Left Arm", imageName: "leftArm")
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                cell.setCellValues(title: "Right Arm", imageName: "rightArm")
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                cell.setCellValues(title: "Left Buttock", imageName: "leftButt")
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                cell.setCellValues(title: "Right Buttock", imageName: "rightButt")
            default:
                cell.textLabel.text = ""
            }
            //move it before return afterrrr creating abdomen grid
            prepareGrid(cell: cell, indexPath: indexPath)
        }
    
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! ARViewController
//        vc.selectedLimb = selectedLimb
//        vc.selectedLimb = .leftThigh
//    }

}

 //MARK: - Collection View Flow Layout Delegate
extension GridCollectionViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    var divider = 3
    switch indexPath.section {
    case 0:
        itemsPerRow = 1
        divider = 3
    default:
        itemsPerRow = 2
        divider = 1
    }
    
    let paddingSpace = sectionInsets.left * (itemsPerRow) + sectionInsets.right * (itemsPerRow)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    cgsize=CGSize(width: widthPerItem, height: widthPerItem/CGFloat(divider))
    return cgsize!
    
    
  }
}

func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}
