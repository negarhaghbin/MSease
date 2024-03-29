//
//  AppDelegate.swift
//  MSease
//
//  Created by Negar on 2021-01-21.
//

import UIKit
import ARKit

let app = RealmManager.shared.connectToMongoDB()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Limb.initTable()
        Symptom.fillSymptomsTable()
        Symptom.fillReactionsTable()
        TSQMquestion.fillTable()
        pretestQuestion.fillTable()
        IPquestion.fillTable()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let viewController = window?.rootViewController as? ARViewController {
            viewController.blurView.isHidden = false
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let viewController = window?.rootViewController as? ARViewController {
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

