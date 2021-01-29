//
//  GridCollectionViewController.swift
//  ARKitInteraction
//
//  Created by Negar on 2021-01-25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

private let GridRectViewCellIdentifier = "GridRectViewCell"
private let GridSquareViewCellIdentifier = "GridSquareViewCell"

struct LimbGridSize {
    static let thigh = (row: 7, col: 5)
    static let arm = (row: 6, col: 3)
    static let buttock = (row: 6, col: 4)
}

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var grid: Array<UIImageView>?
    
    var grid2D : [[UIImageView]] = []
    
    func viewDidLoad() {
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
        
        for i in 0...3{
            for j in 0...3{
                grid2D[i][j] = grid![i*4+j]
                grid2D[i][j].isHidden = false
            }
        }
    }
    
}

class GridCollectionViewController: UICollectionViewController {
    
    enum gridSections : Int {
        case abdomen = 0
        case notAbdomen = 1
    }
    
    enum gridNotAbdomenSectionItems : Int{
        case leftThigh = 0
        case rightThigh = 1
        case leftArm = 2
        case rightArm = 3
        case leftButtock = 4
        case rightButtock = 5
    }

    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 3.0, bottom: 5.0, right: 4.0)
    private var itemsPerRow: CGFloat = 1
    var cgsize : CGSize? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func prepareGrid(cell: GridCollectionViewCell, indexPath: IndexPath){
        if indexPath.section == gridSections.abdomen.rawValue{
            
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                for i in LimbGridSize.thigh.row..<cell.grid2D.count{
                    for j in LimbGridSize.thigh.col..<cell.grid2D[i].count{
                        cell.grid2D[i][j].isHidden = true
                    }
                }
                cell.grid2D[6][0].isHidden = true
                cell.grid2D[6][4].isHidden = true
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                for i in LimbGridSize.thigh.row..<cell.grid2D.count{
                    for j in LimbGridSize.thigh.col..<cell.grid2D[i].count{
                        cell.grid2D[i][j].isHidden = true
                    }
                }
                cell.grid2D[6][0].isHidden = true
                cell.grid2D[6][4].isHidden = true
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                for i in LimbGridSize.arm.row..<cell.grid2D.count{
                    for j in LimbGridSize.arm.col..<cell.grid2D[i].count{
                        cell.grid2D[i][j].isHidden = true
                    }
                }
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                for i in LimbGridSize.arm.row..<cell.grid2D.count{
                    for j in LimbGridSize.arm.col..<cell.grid2D[i].count{
                        cell.grid2D[i][j].isHidden = true
                    }
                }
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                for i in LimbGridSize.buttock.row..<cell.grid2D.count{
                    for j in LimbGridSize.buttock.col..<cell.grid2D[i].count{
                        cell.grid2D[i][j].isHidden = true
                    }
                }
                cell.grid2D[0][3].isHidden = true
                cell.grid2D[3][0].isHidden = true
                cell.grid2D[4][0].isHidden = true
                cell.grid2D[5][0].isHidden = true
                cell.grid2D[4][1].isHidden = true
                cell.grid2D[5][1].isHidden = true
                cell.grid2D[5][2].isHidden = true
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                for i in LimbGridSize.buttock.row..<cell.grid2D.count{
                    for j in LimbGridSize.buttock.col..<cell.grid2D[i].count{
                        cell.grid2D[i][j].isHidden = true
                    }
                }
                cell.grid2D[0][0].isHidden = true
                cell.grid2D[5][1].isHidden = true
                cell.grid2D[4][2].isHidden = true
                cell.grid2D[5][2].isHidden = true
                cell.grid2D[3][3].isHidden = true
                cell.grid2D[4][3].isHidden = true
                cell.grid2D[5][3].isHidden = true
            default:
                print("unknown limb")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 6
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> GridCollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridSquareViewCellIdentifier, for: indexPath) as! GridCollectionViewCell
        
        if indexPath.section == gridSections.abdomen.rawValue{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridRectViewCellIdentifier, for: indexPath) as! GridCollectionViewCell
            cell.textLabel.text = "Abdomen"
            cell.bodyImage.image = imageWithImage(image: UIImage(named: "abdomen")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
        }
        else{
            switch indexPath.row {
            case gridNotAbdomenSectionItems.leftThigh.rawValue:
                cell.textLabel.text = "Left Thigh"
                cell.bodyImage.image = imageWithImage(image: UIImage(named: "leftThigh")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
            case gridNotAbdomenSectionItems.rightThigh.rawValue:
                cell.textLabel.text = "Right Thigh"
                cell.bodyImage.image = imageWithImage(image: UIImage(named: "rightThigh")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
            case gridNotAbdomenSectionItems.leftArm.rawValue:
                cell.textLabel.text = "Left Arm"
                cell.bodyImage.image = imageWithImage(image: UIImage(named: "leftArm")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
            case gridNotAbdomenSectionItems.rightArm.rawValue:
                cell.textLabel.text = "Right Arm"
                cell.bodyImage.image = imageWithImage(image: UIImage(named: "rightArm")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
            case gridNotAbdomenSectionItems.leftButtock.rawValue:
                cell.textLabel.text = "Left Buttock"
                cell.bodyImage.image = imageWithImage(image: UIImage(named: "leftButt")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
            case gridNotAbdomenSectionItems.rightButtock.rawValue:
                cell.textLabel.text = "Right Buttock"
                cell.bodyImage.image = imageWithImage(image: UIImage(named: "rightButt")!, scaledToSize:CGSize(width: cgsize!.width*0.4, height: cgsize!.height-sectionInsets.top-sectionInsets.bottom))
            default:
                cell.textLabel.text = ""
            }
            //move it before return afterrrr creating abdomen grid
            prepareGrid(cell: cell, indexPath: indexPath)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + sectionInsets.right * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    cgsize=CGSize(width: widthPerItem, height: widthPerItem/CGFloat(divider))
    return cgsize!
    
    
  }

//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      insetForSectionAt section: Int) -> UIEdgeInsets {
//    return sectionInsets
//  }
//
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return sectionInsets.left
//  }
}

func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}
