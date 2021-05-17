//
//  WalkthroughViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import UIKit

class WalkthroughViewController: UIViewController, pageViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var skipButton : UIButton!
    
    @IBOutlet weak var authenticationStackView : UIStackView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Variables
    var walkthroughPageViewController : WalkthroughPageViewController?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        pageControl.numberOfPages = walkthroughPages.count
        pageControl.currentPageIndicatorTintColor = StylingUtilities.buttonColor
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
                dismiss(animated: true)
            default:
                break
            }
        }
        updateUI()
    }
    
    @IBAction func skipButtonTapped(sender: UIButton){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...walkthroughPages.count-2:
                let counter = walkthroughPages.count-1-index
                walkthroughPageViewController?.forwardPage(counter: counter)
            default:
                break
            }
        }
        
        updateUI()
    }
    
    // MARK: - Helpers
    func setUpElements(){
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(skipButton)
        
        StylingUtilities.styleFilledButton(signupButton)
        StylingUtilities.styleHollowdButton(loginButton)
        
        pageControl.numberOfPages = walkthroughPages.count
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
