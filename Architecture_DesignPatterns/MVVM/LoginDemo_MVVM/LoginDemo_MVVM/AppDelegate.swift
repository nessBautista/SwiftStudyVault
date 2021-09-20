//
//  AppDelegate.swift
//  LoginDemo_MVVM
//
//  Created by Nestor Hernandez on 14/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let injectionContainer =  DemoAppDependencyContainer()
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let mainVC = injectionContainer.makeMainViewController()
        self.window?.rootViewController = mainVC
        
        // Override point for customization after application launch.
        return true
    }
}

