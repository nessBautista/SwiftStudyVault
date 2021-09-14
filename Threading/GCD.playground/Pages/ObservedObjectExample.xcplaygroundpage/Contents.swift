//: [Previous](@previous)

import Foundation
import Combine
import UIKit
class User: ObservableObject {
    @Published var userName: String
    @Published var profileImage: UIImage
    var id: String = String()
    init(userName: String = "Ness",
         profileImage: UIImage = UIImage(named:"nature")!) {
        self.userName = userName
        self.profileImage = profileImage
    }
}

let ness = User()
ness.profileImage

// Create an observer to this user
var subscriptions = Set<AnyCancellable>()
ness.$profileImage.sink { image in
    print("Observed image was changed")
    image
}.store(in: &subscriptions)


// Change the user Image
let newImage = UIImage(named:"dark_road_small.jpg")!
ness.profileImage = newImage


//: [Next](@next)
