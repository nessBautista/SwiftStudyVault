//
//  AppDelegate.swift
//  ModernLayouts
//
//  Created by Nestor Hernandez on 13/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let rootVc = HomeViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = UINavigationController(rootViewController: rootVc)
        
        return true
    }

}

