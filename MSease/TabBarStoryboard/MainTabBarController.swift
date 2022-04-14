//
//  MainTabBarController.swift
//  MSease
//
//  Created by Negar on 2021-05-06.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Properties
    
    enum TabIndex: Int {
        case home = 0
        case calendar
        case injection
        case reminders
        case settings
    }
    
    var bgView: UIView?
    
    let mainButtonIndex = 2
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = StylingUtilities.buttonColor
        delegate = self
        let prominentTabBar = tabBar as! CenterTabBarButton
        prominentTabBar.prominentButtonCallback = prominentTabTaped
        
        createCenterButton(bgColor: StylingUtilities.buttonColor!)
    }
    
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        bgView?.backgroundColor = StylingUtilities.buttonColor
        if viewController == viewControllers![TabIndex.reminders.rawValue]{
            let navVC = viewController as! UINavigationController
            let vc = navVC.topViewController as! reminderSettingsViewController
            vc.tableView?.reloadData()
        }
    }
    
    
    // MARK: - Helpers
    func prominentTabTaped() {
        selectedIndex = (tabBar.items?.count ?? 0)/2
        bgView?.backgroundColor = UIColor(hex: StylingUtilities.circleColor)
    }
    
    private func createCenterButton(bgColor: UIColor) {
        let itemIndex:CGFloat = 2.0
        let itemWidth:CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let offset = itemWidth > 100 ? (itemWidth-100)/2 : 0
        let realWidth = itemWidth > 100 ? 100 : itemWidth
        
        bgView = UIView(frame: CGRect.init(x: (itemWidth * itemIndex) + offset, y: (-itemWidth/2) + offset, width: realWidth , height: realWidth))
        if let bgView = bgView {
            bgView.layer.cornerRadius = bgView.frame.size.width/2
            bgView.clipsToBounds = true
            bgView.isUserInteractionEnabled = true
            bgView.backgroundColor = bgColor
            
            let newWidth = bgView.frame.size.width - (realWidth / 2)
            let newHeight = bgView.frame.size.height - (realWidth / 2)
            let newSize = CGSize(width: newWidth, height: newHeight)
            let image = UIImage(named: "syringe")?.scaleTo(newSize: newSize )
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = true
            
            bgView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: newSize.width),
                imageView.heightAnchor.constraint(equalToConstant: newSize.height),
                imageView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
            ])
            tabBar.insertSubview(bgView, at: mainButtonIndex)
        }
    }
}
