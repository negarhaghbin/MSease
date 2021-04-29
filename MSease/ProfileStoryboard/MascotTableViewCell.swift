//
//  MascotTableViewCell.swift
//  MSease
//
//  Created by Negar on 2021-04-27.
//

import UIKit

class MascotTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
