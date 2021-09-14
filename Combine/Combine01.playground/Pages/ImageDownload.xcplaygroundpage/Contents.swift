//: [Previous](@previous)

import UIKit
import Accelerate
import Combine
enum ImageError: Error {
    case downloadError
}
let backgroundQueue = DispatchQueue(label: "DispatchQueue", qos: .background)
let userQueue = DispatchQueue(label: "DispatchQueueUser", qos: .userInitiated)
let url = URL(string: "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-467028-jpeg.jpg")!
let publisher = URLSession.shared.dataTaskPublisher(for: url)

let subscriber = publisher
    .print()
    .subscribe(on: backgroundQueue)
    .tryMap { (data, response) -> UIImage in
        print("Received image in Thread: \(Thread.current)")
        if let image = UIImage(data: data) {
            return image
        }
        throw ImageError.downloadError
    }
    .receive(on: userQueue)
    .tryMap({ image -> UIImage in
        print("Applied filter image in Thread: \(Thread.current)")
        if let blurImage = image.applyBlurWithRadius(10) {
            return blurImage
        }
        throw ImageError.downloadError
    })
    .receive(on: RunLoop.main)
    .sink { completion in
        print(completion)
    } receiveValue: { image in
        print("current Thread: \(Thread.current)")
        image
    }

    
//: [Next](@next)
