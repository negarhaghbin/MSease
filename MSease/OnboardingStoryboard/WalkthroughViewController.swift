//
//  WalkthroughViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import UIKit

class WalkthroughViewController: UIViewController, walkthroughPageViewControllerDelegate {
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }

    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var skipButton : UIButton!
    
    
    var walkthroughPageViewController : WalkthroughPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(sender: UIButton){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...walkthroughPages.count-2:
                walkthroughPageViewController?.forwardPage()
            case walkthroughPages.count-1:
                dismiss(animated: true)
            default:
                break
            }
        }
        
        updateUI()
    }
    
    func updateUI(){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...walkthroughPages.count-2:
                nextButton.setTitle("Next", for: .normal)
                skipButton.isHidden = false
            case walkthroughPages.count-1:
                nextButton.setTitle("Get started", for: .normal)
                skipButton.isHidden = true
            default:
                break
            }
            
            pageControl.currentPage = index
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController{
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    

}
