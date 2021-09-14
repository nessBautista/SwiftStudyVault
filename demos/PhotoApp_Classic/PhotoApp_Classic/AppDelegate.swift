//
//  AppDelegate.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupRootVC()
        return true
    }
    
    private func setupRootVC() {
        let rootVC = TabBarController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = rootVC
        self.coordinator = Coordinator(rootVC: rootVC)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

extension AppDelegate: ProcessLifeCycle {
    func handlerDidStart() {
        print("SetupSessionProcess started")
    }
    
    func didAddLog(message: String) {
        print(message)
    }
    
    func handlerDidFinish(finishedWithError: ProcessError?) {
        guard let error = finishedWithError else {
            print("SetupSessionProcess process finished successfully")
            return
        }
        print("SetupSessionProcess finished with error: \(error)")
    }
    
    
}
