//
//  Constants.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 21/06/21.
//

import Foundation

enum Constants {
    enum Keys: String {
        case UnsplashAPI
    }
    
    enum Session: String {
        case accessToken
        case isLoggedIn
    }
    static let CoordinatorNavigationRequest: Notification.Name = Notification.Name.init("Navigation")
    
    enum Coordinator: String {
        case Navigation
    }
}
