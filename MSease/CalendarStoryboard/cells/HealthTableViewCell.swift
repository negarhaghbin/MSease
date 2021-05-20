//
//  HealthTableViewCell.swift
//  MSease
//
//  Created by Negar on 2021-05-19.
//

import UIKit

var healthData = [
    (image: "flame", title: "Steps", measurementUnit: "steps"),
    (image: "heart", title: "Heart Rate", measurementUnit: "BPM")]

class HealthTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var measurementUnitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initiate(count: Int){
        let cellData = healthData[tag]
        titleLabel.text = cellData.title
        imageview.image = UIImage(systemName: cellData.image)
        
        if count == -1{
            countLabel.text = "No data"
            measurementUnitLabel.text = ""
        }
        else{
            countLabel.text = String(count)
            measurementUnitLabel.text = cellData.measurementUnit
        }
        
    }

}
