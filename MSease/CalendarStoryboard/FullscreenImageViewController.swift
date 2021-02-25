//
//  FullscreenImageViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-24.
//

import UIKit

class FullscreenImageViewController: UIViewController {

    var imageViewURL : URL?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        let data = try? Data(contentsOf: imageViewURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        imageView.image = UIImage(data: data!)
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
