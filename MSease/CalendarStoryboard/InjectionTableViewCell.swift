//
//  InjectionTableViewCell.swift
//  MSease
//
//  Created by Negar on 2021-05-05.
//

import UIKit
import RealmSwift

class InjectionTableViewCell: UITableViewCell {

    @IBOutlet weak var limbLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initiate(injections: Results<Injection>){
        limbLabel.text = injections[tag].limbName
        timeLabel.text = injections[tag].time
        if injections[tag].painScale > 0{
            imageview.image = UIImage(named: painScale[injections[tag].painScale-1])
        }
        else{
            imageview.image = UIImage()
        }
    }

}
