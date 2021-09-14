//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
class ImageLoadOperation: AsyncOperation {
    
    private let url: URL
    var image: UIImage?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func main() {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {return}
            defer { self.state = .finished }
            guard error == nil, let data = data else {return}
            self.image = UIImage(data: data)
        }.resume()
    }
}


let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052]
var images: [UIImage] = []
let queue = OperationQueue()

for id in ids {
    guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { continue }
    let op = ImageLoadOperation(url: url)
    op.completionBlock = {
        if let image = op.image {
            images.append(image)
        }
    }
    queue.addOperation(op)
}
duration {
    queue.waitUntilAllOperationsAreFinished()
}

images
PlaygroundPage.current.finishExecution()

//: [Next](@next)
