//
//  TabBarController.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 13/06/21.
//

import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        UINavigationBar.appearance().prefersLargeTitles = true
        self.viewControllers = [getHome(), ProfileViewController()]
    }
    
    func getHome() -> UIViewController {
        let vc = HomeViewController()
        vc.title = "home"
        return vc
    }
    
}


