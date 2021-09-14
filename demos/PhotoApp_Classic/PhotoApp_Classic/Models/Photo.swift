//
//  Photo.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import Foundation
enum UnsplashURL: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

class Photo: NSObject, Decodable {
    var id:String
    var alt_description:String?
    var width:Int
    var height:Int
    var color:String
    var created_at:String
    var likes:Int
    var liked_by_user:Bool
    //var description:String?
    var urls:[String:String]
    var links:[String:String]
    var user:User
}
