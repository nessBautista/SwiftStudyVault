//
//  User.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import Foundation
struct User: Decodable, Hashable {
    var id:String
    var username:String
    var name: String
    var location:String?
    var links:[String:String]
    var profile_image:[String:String]
}
