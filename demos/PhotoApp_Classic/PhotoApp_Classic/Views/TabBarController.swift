//
//  TabBarController.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = self.getViewControllers()
    }
    
    func getViewControllers() -> [UIViewController]{
        let vc = HomeViewController()
        vc.title = "home"
        return [vc]
    }

}
