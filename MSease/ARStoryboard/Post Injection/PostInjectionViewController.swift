//
//  PostInjectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-09.
//

import UIKit

class PostInjectionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var painScale1 : UIButton!
//    @IBOutlet weak var painScale2 : UIButton!
    @IBOutlet weak var painScale3 : UIButton!
//    @IBOutlet weak var painScale4 : UIButton!
    @IBOutlet weak var painScale5 : UIButton!
//    @IBOutlet weak var painScale6 : UIButton!
    @IBOutlet weak var painScale7 : UIButton!
//    @IBOutlet weak var painScale8 : UIButton!
    @IBOutlet weak var painScale9 : UIButton!
//    @IBOutlet weak var painScale10 : UIButton!
    
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StylingUtilities.stylePainscaleButton(painScale1, range: 1)
//        StylingUtilities.stylePainscaleButton(painScale2, range: 2)
        StylingUtilities.stylePainscaleButton(painScale3, range: 3)
//        StylingUtilities.stylePainscaleButton(painScale4, range: 4)
        StylingUtilities.stylePainscaleButton(painScale5, range: 5)
//        StylingUtilities.stylePainscaleButton(painScale6, range: 6)
        StylingUtilities.stylePainscaleButton(painScale7, range: 7)
//        StylingUtilities.stylePainscaleButton(painScale8, range: 8)
        StylingUtilities.stylePainscaleButton(painScale9, range: 9)
//        StylingUtilities.stylePainscaleButton(painScale10, range: 10)
    }
    
    // MARK: - Actions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
