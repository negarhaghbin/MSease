//
//  MainTabBarController.swift
//  MSease
//
//  Created by Negar on 2021-05-06.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var bgView : UIView?
    enum tabIndex : Int{
        case home = 0
        case insight
        case injection
        case calendar
        case settings
    }
    let mainButtonIndex = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(hex: StylingUtilities.buttonColor)
        delegate = self
        let prominentTabBar = self.tabBar as! CenterTabBarButton
        prominentTabBar.prominentButtonCallback = prominentTabTaped
        
        createCenterButton(bgColor: UIColor(hex: StylingUtilities.buttonColor)!)
    }
    
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        bgView?.backgroundColor = UIColor(hex: StylingUtilities.buttonColor)
        switch tabBar.selectedItem{
        case tabBar.items![tabIndex.injection.rawValue]:
            bgView?.backgroundColor = UIColor(hex: StylingUtilities.circleColor)
        default:
            print("default")
        }
    }
    
    // MARK: - Helpers
    func prominentTabTaped() {
        selectedIndex = (tabBar.items?.count ?? 0)/2
    }
    
    private func createCenterButton(bgColor: UIColor) {
        let itemIndex:CGFloat = 2.0
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        bgView = UIView(frame: CGRect.init(x: itemWidth * itemIndex, y: -itemWidth/2, width: itemWidth, height: itemWidth))
        bgView!.layer.cornerRadius = bgView!.frame.size.width/2
        bgView!.clipsToBounds = true
//        bgView!.backgroundColor = bgColor
//        bgView
        
        let newSize = CGSize(width: bgView!.frame.size.width-30.0, height: bgView!.frame.size.height-30.0)
        let image = UIImage(named: "syringe-white2")?
            .scaleTo(newSize: newSize )
        let imageView = UIImageView(image: image)
//        imageView.UserInteractionEnabled = true
        
        bgView!.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: newSize.width),
            imageView.heightAnchor.constraint(equalToConstant: newSize.height),
            imageView.centerXAnchor.constraint(equalTo: bgView!.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: bgView!.centerYAnchor)
        ])
        tabBar.insertSubview(bgView!, at: mainButtonIndex)

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
