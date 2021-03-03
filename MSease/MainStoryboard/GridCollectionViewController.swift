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
    
    var grid2D : [[UIImageView]] = Array(repeating: Array(repeating: UIImageView(), count: LimbGridSize.gridSize().col), count: LimbGridSize.gridSize().row)
    
    func setCellValues(title: String, imageName: String, section: Int){
        self.textLabel.text = title
        let scaledSize = CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom)
        self.bodyImage.image = imageWithImage(image: UIImage(named: imageName)!, scaledToSize:scaledSize)
    }
    
    func initiate(){
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.minimumScaleFactor = 0.5
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
    
//    func create2DGridFrom1D(){
//        self.grid = self.grid!.sorted { $0.tag < $1.tag }
//        for i in 0..<LimbGridSize.gridSize().row{
//            for j in 0..<LimbGridSize.gridSize().col{
//                self.grid2D[i][j] = self.grid![i*LimbGridSize.gridSize().col+j]
//                self.grid2D[i][j].isHidden = false
//            }
//        }
//    }
    func prepareGrid(limb: limb){
        if limb == .abdomen{
            createGrid(row: LimbGridSize.abdomen.row, col: LimbGridSize.abdomen.col, hidden: LimbGridSize.abdomen.hidden)
        }
        else{
            switch limb {
            case .leftThigh:
                createGrid(row: LimbGridSize.thigh.row, col: LimbGridSize.thigh.col, hidden: LimbGridSize.thigh.hidden)
            case .rightThigh:
                createGrid(row: LimbGridSize.thigh.row, col: LimbGridSize.thigh.col, hidden: LimbGridSize.thigh.hidden)
            case .leftArm:
                createGrid(row: LimbGridSize.arm.row, col: LimbGridSize.arm.col, hidden: [])
            case .rightArm:
                createGrid(row: LimbGridSize.arm.row, col: LimbGridSize.arm.col, hidden: [])
            case .leftButtock:
                createGrid(row: LimbGridSize.leftButtock.row, col: LimbGridSize.leftButtock.col, hidden: LimbGridSize.leftButtock.hidden)
            case .rightButtock:
                createGrid(row: LimbGridSize.rightButtock.row, col: LimbGridSize.rightButtock.col, hidden: LimbGridSize.rightButtock.hidden)
            default:
                print("unknown limb")
            }
        }
    }
    
    private func createGrid(row: Int, col: Int, hidden: [(Int, Int)]){
        let width : Double?
        if col == LimbGridSize.abdomen.col{
            width = Double(self.frame.width/20)
        }
        else{
            width = Double(self.frame.width/10)
        }
        
        for i in 0...row-1{
            for j in 0...col-1{
                let xVal = Double((0.75+Double(j))*width! - Double(2*j))
                let yVal = Double((2.25+Double(i))*width! - Double(i))
                let frame = CGRect(x: xVal, y: yVal, width: width!, height: width!)
                let imageView = UIImageView(frame: frame)
                imageView.image = UIImage(systemName: "square.fill")
                grid2D[i][j] = imageView
                self.contentView.addSubview(imageView)
            }
        }
        hideExtraRowsAndCols(row: row, col:col, hidden: hidden)
    }
    
}

class GridCollectionViewController: UICollectionViewController {
    private let GridSquareViewCellIdentifier = "GridSquareViewCell"
    
    var selectedLimb : limb?
    
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
        self.title = "Choose a body part"

    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == gridSections.abdomen.rawValue{
            selectedLimb = .abdomen
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                selectedLimb = .leftArm
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                selectedLimb = .rightArm
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                selectedLimb = .leftThigh
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                selectedLimb = .rightThigh
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                selectedLimb = .leftButtock
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                selectedLimb = .rightButtock
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridSquareViewCellIdentifier, for: indexPath) as! GridCollectionViewCell
        
        cell.initiate()
        
        if indexPath.section == gridSections.abdomen.rawValue{
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridRectViewCellIdentifier, for: indexPath) as! GridCollectionViewCell
            
            cell.setCellValues(title: "Abdomen", imageName: "abdomen", section: gridSections.abdomen.rawValue)
            cell.prepareGrid(limb: .abdomen)
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                cell.setCellValues(title: "Left Thigh", imageName: "leftThigh", section: gridSections.notAbdomen.rawValue)
                cell.prepareGrid(limb: .leftThigh)
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                cell.setCellValues(title: "Right Thigh", imageName: "rightThigh", section: gridSections.notAbdomen.rawValue)
                cell.prepareGrid(limb: .rightThigh)
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                cell.setCellValues(title: "Left Arm", imageName: "leftArm", section: gridSections.notAbdomen.rawValue)
                cell.prepareGrid(limb: .leftArm)
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                cell.setCellValues(title: "Right Arm", imageName: "rightArm", section: gridSections.notAbdomen.rawValue)
                cell.prepareGrid(limb: .rightArm)
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                cell.setCellValues(title: "Left Buttock", imageName: "leftButt", section: gridSections.notAbdomen.rawValue)
                cell.prepareGrid(limb: .leftButtock)
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                cell.setCellValues(title: "Right Buttock", imageName: "rightButt", section: gridSections.notAbdomen.rawValue)
                cell.prepareGrid(limb: .rightButtock)
            default:
                cell.textLabel.text = ""
            }
            
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
    var divider = 2.0
    switch indexPath.section {
    case 0:
        itemsPerRow = 1
        divider = 2.05
    default:
        itemsPerRow = 2
        divider = 1.05
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
