//
//  GridCollectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-25.
//

import UIKit

private let sectionInsets = UIEdgeInsets(top: 5.0, left: 4.0, bottom: 5.0, right: 4.0)
var cgsize : CGSize? = nil

class GridCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    private let GridSquareViewCellIdentifier = "GridSquareViewCell"
    
    var selectedLimbName : String?
    var cellsWithPrevInjections : [(x: Int, y: Int, color: String)] = []
    var selectedIndexPath : IndexPath?
    
    enum gridSections : Int {
        case abdomen = 0
        case notAbdomen
    }
    
    enum gridNotAbdomenSectionItems : Int, CaseIterable{
        case leftThigh = 0
        case rightThigh
        case leftArm
        case rightArm
        case leftButtock
        case rightButtock
    }
    
//    lazy var partitionValue = RealmManager.shared.getPartitionValue()

    private var itemsPerRow: CGFloat = 1
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.isIdleTimerDisabled = false
        collectionView.reloadData()
//        if selectedIndexPath != nil{
//            self.collectionView.reloadItems(at: [selectedIndexPath!])
//        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.section == gridSections.abdomen.rawValue{
            selectedLimbName =  limb.abdomen.rawValue
        }
        else{
            selectedLimbName = limbs[indexPath.row + 1].name
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GridCollectionViewCell{
            cellsWithPrevInjections = cell.prevInjectionCells
        }
        performSegue(withIdentifier: "showAR", sender: nil)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridSquareViewCellIdentifier, for: indexPath) as? GridCollectionViewCell else{
            return GridCollectionViewCell()
        }
        
        var limbIndex = 0
        for i in 0..<indexPath.section{
            limbIndex += collectionView.numberOfItems(inSection: i)
        }
        limbIndex += indexPath.row
        cell.tag = limbIndex
        cell.initiate()
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ARViewController{
            vc.selectedLimbName = selectedLimbName
            vc.cellsWithInjections = cellsWithPrevInjections
        }
    }

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
