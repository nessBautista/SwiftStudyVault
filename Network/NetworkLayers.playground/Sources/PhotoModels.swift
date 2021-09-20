import Foundation

public struct Photo: Codable {
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
public struct User: Codable {
    
    var id:String
    var username:String
    var name: String
    var location:String?
    var links:[String:String]
    var profile_image:[String:String]
}
