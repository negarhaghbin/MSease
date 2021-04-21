//
//  ArTutorialPageViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-21.
//

import UIKit

class ArTutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Variables
    var tutorialDelegate : pageViewControllerDelegate?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if arTutorialPages.count == 0{
            Page.fillARTutorialPages()
        }
        dataSource = self
        delegate = self
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ArTutorialContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ArTutorialContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    // MARK: - Helper
    func contentViewController(at index: Int) -> ArTutorialContentViewController? {
        if index<0 || index>arTutorialPages.count-1{
            return nil
        }
        
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "TutorialContentViewController") as? ArTutorialContentViewController{
            pageContentViewController.descriptionText = arTutorialPages[index].subheading!
            pageContentViewController.imageName = arTutorialPages[index].imageName!
            
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    
    func forwardPage(){
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let contentViewController = pageViewController.viewControllers?.first as? ArTutorialContentViewController{
                currentIndex = contentViewController.index
                tutorialDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
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
