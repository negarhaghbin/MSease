//
//  WalkthroughPageViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import UIKit

protocol walkthroughPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Properties
    var walkthroughDelegate : walkthroughPageViewControllerDelegate?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillWalkthroughPages()
        dataSource = self
        delegate = self
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    // MARK: - Helper
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index<0 || index>walkthroughPages.count-1{
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "WalkthroughContentViewController") as? WalkthroughContentViewController{
            pageContentViewController.titleText = walkthroughPages[index].heading!
            pageContentViewController.descriptionText = walkthroughPages[index].subheading!
            pageContentViewController.imageName = walkthroughPages[index].imageName!
            
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
            print("currentIndex")
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController{
                currentIndex = contentViewController.index
                print(currentIndex)
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
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
