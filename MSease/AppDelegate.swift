//
//  AppDelegate.swift
//  MSease
//
//  Created by Negar on 2021-01-21.
//

import UIKit
import ARKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        RealmManager.shared.printPath()
        if isNewUser(){
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            RealmManager.shared.fillSymptomsTable()
            RealmManager.shared.fillLimbTable()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARViewController {
            viewController.blurView.isHidden = false
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARViewController {
            viewController.blurView.isHidden = true
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

}

func isNewUser()->Bool{
    let defaults = UserDefaults.standard
    if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
        return false
    }
    else{
        return true
    }
}

