//
//  Photo.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 14/07/21.
//

import Foundation

struct Photo: Codable {
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
