//
//  ArTutorialViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-21.
//

import UIKit

class ArTutorialViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var skipButton : UIButton!
    
    // MARK: - Variables
    var tutorialPageViewController : ArTutorialPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    // MARK: - Actions
    @IBAction func nextButtonTapped(sender: UIButton){
        if let index = tutorialPageViewController?.currentIndex{
            switch index {
            case 0...arTutorialPages.count-2:
                tutorialPageViewController?.forwardPage()
            case arTutorialPages.count-1:
                dismiss(animated: true)
            default:
                break
            }
        }
        updateUI()
    }
    
    @IBAction func skipButtonTapped(sender: UIButton){
        dismiss(animated: true)
        updateUI()
    }
    
    
    // MARK: - Helpers
    func setUpElements(){
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(skipButton)
        
        pageControl.numberOfPages = arTutorialPages.count
        pageControl.currentPageIndicatorTintColor = UIColor(hex: StylingUtilities.buttonColor)
    }
    
    func updateUI(){
        if let index = tutorialPageViewController?.currentIndex{
            switch index {
            case 0...arTutorialPages.count-2:
                nextButton.setTitle("Next", for: .normal)
                
            case arTutorialPages.count-1:
                nextButton.setTitle("Get started", for: .normal)
                
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
        if let pageViewController = destination as? ArTutorialPageViewController{
            tutorialPageViewController = pageViewController
            tutorialPageViewController?.tutorialDelegate = self
        }
    }

}


// MARK: - pageViewControllerDelegate
extension ArTutorialViewController: pageViewControllerDelegate{
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
