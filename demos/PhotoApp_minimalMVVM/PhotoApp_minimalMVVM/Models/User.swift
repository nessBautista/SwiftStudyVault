//
//  User.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 14/07/21.
//

import Foundation

struct User: Codable {
    
    var id:String
    var username:String
    var name: String
    var location:String?
    var links:[String:String]
    var profile_image:[String:String]
}
