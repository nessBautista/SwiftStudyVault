//
//  Coordinator.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 21/06/21.
//

import Foundation
import UIKit 
enum AppScreen {
    case login
    case home
    case settings
    case logout
    
}

protocol CoordinatorProtocol: AnyObject {
    var current: AppScreen {get set}
    var rootVC: UIViewController? { get set}
    func goNext()
    func goPrevious()
    
}

class Coordinator: CoordinatorProtocol {
    var current: AppScreen = .home
    
    var rootVC: UIViewController?
    
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
        NotificationCenter.default.addObserver(self, selector: #selector(respondToNotification(_:)), name: Constants.CoordinatorNavigationRequest, object: nil)
    }
    func goNext() {
        
    }
    
    func goPrevious() {
        
    }
    
    @objc func respondToNotification(_ notification: Notification) {
        if let screen = notification.object as? AppScreen {
            print("will go to: \(screen)")
        }
    }
    
    
}
