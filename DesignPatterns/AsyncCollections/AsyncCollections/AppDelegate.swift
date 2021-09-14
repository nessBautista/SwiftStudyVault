//
//  AppDelegate.swift
//  AsyncCollections
//
//  Created by Nestor Hernandez on 02/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //set the root view controller
        let rootVC = IndexList()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()

        self.window?.rootViewController = UINavigationController(rootViewController: rootVC)
        
        return true
    }

}

