//
//  Photo.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 12/06/21.
//

import Foundation
enum UnsplashURL: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

struct Photo: Decodable, Hashable {
    var id:String
    var alt_description:String?
    var width:Int
    var height:Int
    var color:String
    var created_at:String
    var likes:Int
    var liked_by_user:Bool
    var description:String?
    var urls:[String:String]
    var links:[String:String]
    var user:User
}
