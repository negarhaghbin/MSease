//
//  NotesTableViewCell.swift
//  MSease
//
//  Created by Negar on 2021-02-14.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addNewNoteLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(isNoteInstance: Bool){
        self.addNewNoteLabel.isHidden = isNoteInstance
        self.contentLabel.isHidden = !isNoteInstance
        self.timeLabel.isHidden = !isNoteInstance
        self.collectionView.isHidden = !isNoteInstance
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}
