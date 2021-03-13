//
//  WalkthroughContentViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    
    // MARK: -Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    // MARK: -Properties
    var index = 0
    var titleText = ""
    var descriptionText = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = titleText
        descriptionLable.text = descriptionText
        imageView.image = UIImage(named: imageName)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
