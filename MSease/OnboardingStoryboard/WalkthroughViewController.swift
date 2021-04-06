//
//  WalkthroughViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import UIKit

class WalkthroughViewController: UIViewController, walkthroughPageViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var skipButton : UIButton!
    
    @IBOutlet weak var authenticationStackView : UIStackView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var walkthroughPageViewController : WalkthroughPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - walkthroughPageViewControllerDelegate
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction func nextButtonTapped(sender: UIButton){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...walkthroughPages.count-2:
                walkthroughPageViewController?.forwardPage()
            case walkthroughPages.count-1:
                // FIXME: next button is hidden in this page
                dismiss(animated: true)
            default:
                break
            }
        }
        
        updateUI()
    }
    
    // MARK: - Helpers
    func setUpElements(){
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleFilledButton(signupButton)
        StylingUtilities.styleHollowdButton(loginButton)
    }
    
    func updateUI(){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...walkthroughPages.count-2:
                nextButton.setTitle("Next", for: .normal)
                nextButton.isHidden = false
                skipButton.isHidden = false
                authenticationStackView.isHidden = true
            case walkthroughPages.count-1:
//                nextButton.setTitle("Get started", for: .normal)
                nextButton.isHidden = true
                skipButton.isHidden = true
                authenticationStackView.isHidden = false
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
        if let destinationVC = destination as? SignupLoginViewController{
            if segue.identifier == "signup"{
                destinationVC.isLoggingIn = false
            }
            else if segue.identifier == "login"{
                destinationVC.isLoggingIn = true
                
            }
        }
    }
    

}
