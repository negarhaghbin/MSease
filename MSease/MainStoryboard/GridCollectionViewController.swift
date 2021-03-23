//
//  GridCollectionViewController.swift
//  ARKitInteraction
//
//  Created by Negar on 2021-01-25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RealmSwift

private let sectionInsets = UIEdgeInsets(top: 5.0, left: 4.0, bottom: 5.0, right: 4.0)
var cgsize : CGSize? = nil

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var grid2D : [[UIImageView]] = []
        //Array(repeating: Array(repeating: UIImageView(), count: LimbGridSize.gridSize().col), count: LimbGridSize.gridSize().row)
    
    func setCellValues(title: String, imageName: String, section: Int){
        self.textLabel.text = title
        let scaledSize = CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom)
        self.bodyImage.image = imageWithImage(image: UIImage(named: imageName)!, scaledToSize:scaledSize)
    }
    
    func initiate(){
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.minimumScaleFactor = 0.5
    }
    
    func hideExtraRowsAndCols(hidden:[(x: Int, y: Int)]){
//        for i in row..<LimbGridSize.gridSize().row{
//            for j in 0..<LimbGridSize.gridSize().col{
//                self.grid2D[i][j].isHidden = true
//            }
//        }
//        for i in col..<LimbGridSize.gridSize().col{
//            for j in 0..<LimbGridSize.gridSize().row{
//                self.grid2D[j][i].isHidden = true
//            }
//        }
        for block in hidden{
            self.grid2D[block.x][block.y].isHidden = true
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
    
    func prepareGrid(limbGrid: Limb){
        print("in prepare grid")
        // FIXME:
        let realm = try! Realm()
        let injections = RealmManager.shared.getInjectionsForLimb(limb: limbGrid, realm: realm)
        var cells : [(x: Int, y: Int)] = []
        for injection in injections{
            cells.append((x: injection.selectedCellX, y: injection.selectedCellY))
        }
        print("after injections")
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
                let xVal = Double((0.75+Double(j))*width! - Double(2*j))
                let yVal = Double((2.25+Double(i))*width! - Double(i))
                let frame = CGRect(x: xVal, y: yVal, width: width!, height: width!)
                let imageView = UIImageView(frame: frame)
                imageView.image = UIImage(systemName: "square.fill")
                if cells.contains(where: { pair in
                    return (pair.x == i) && (pair.y == j)
                }){
                    imageView.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                }
                grid2D[i].append(imageView)
                self.contentView.addSubview(imageView)
            }
        }
        hideExtraRowsAndCols(hidden: Array(limbGrid.hiddenCells))
    }
    
}

class GridCollectionViewController: UICollectionViewController {
    private let GridSquareViewCellIdentifier = "GridSquareViewCell"
    
    var selectedLimbName : String?
    var selectedIndexPath : IndexPath?
    
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
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Choose a body part"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedIndexPath != nil{
            self.collectionView.reloadItems(at: [selectedIndexPath!])
        }
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == gridSections.abdomen.rawValue{
            selectedLimbName =  limb.abdomen.rawValue
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                selectedLimbName =  limb.leftArm.rawValue
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                selectedLimbName =  limb.rightArm.rawValue
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                selectedLimbName =  limb.leftThigh.rawValue
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                selectedLimbName =  limb.rightThigh.rawValue
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                selectedLimbName =  limb.leftButtock.rawValue
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                selectedLimbName =  limb.rightButtock.rawValue
            default:
                print("unknown limb")
            }
            
        }
        
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ARVC") as! ARViewController
        vc.selectedLimbName = selectedLimbName
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
            
            cell.setCellValues(title: limb.abdomen.rawValue, imageName: "abdomen", section: gridSections.abdomen.rawValue)
            let abdomen = Limb.getLimb(name: limb.abdomen.rawValue)
            cell.prepareGrid(limbGrid: abdomen)
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                cell.setCellValues(title: limb.leftThigh.rawValue, imageName: "leftThigh", section: gridSections.notAbdomen.rawValue)
                let leftThigh = Limb.getLimb(name: limb.leftThigh.rawValue)
                cell.prepareGrid(limbGrid: leftThigh)
                
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                cell.setCellValues(title: limb.rightThigh.rawValue, imageName: "rightThigh", section: gridSections.notAbdomen.rawValue)
                let rightThigh = Limb.getLimb(name: limb.rightThigh.rawValue)
                cell.prepareGrid(limbGrid: rightThigh)
                
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                cell.setCellValues(title: limb.leftArm.rawValue, imageName: "leftArm", section: gridSections.notAbdomen.rawValue)
                let leftArm = Limb.getLimb(name: limb.leftArm.rawValue)
                cell.prepareGrid(limbGrid: leftArm)
                
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                cell.setCellValues(title: limb.rightArm.rawValue, imageName: "rightArm", section: gridSections.notAbdomen.rawValue)
                let rightArm = Limb.getLimb(name: limb.rightArm.rawValue)
                cell.prepareGrid(limbGrid: rightArm)
                
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                cell.setCellValues(title: limb.leftButtock.rawValue, imageName: "leftButt", section: gridSections.notAbdomen.rawValue)
                let leftButtock = Limb.getLimb(name: limb.leftButtock.rawValue)
                cell.prepareGrid(limbGrid: leftButtock)
                
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                cell.setCellValues(title: limb.rightButtock.rawValue, imageName: "rightButt", section: gridSections.notAbdomen.rawValue)
                let rightButtock = Limb.getLimb(name: limb.rightButtock.rawValue)
                cell.prepareGrid(limbGrid: rightButtock)
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
