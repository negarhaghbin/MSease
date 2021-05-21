//
//  ArTutorialContentViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-21.
//

import UIKit

class ArTutorialContentViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLable: UILabel!
    
    // MARK: - Variables
    var index = 0
    var descriptionText = ""
    var imageName = ""
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLable.text = descriptionText
        imageView.loadGif(name: imageName)
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
