//: [Previous](@previous)

import Foundation
import Combine
import UIKit

class ViewModel {
    @Published var image: UIImage?
    var subscriptions = Set<AnyCancellable>()
    func downloadImage() {
        let url = URL(string: "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-467028-jpeg.jpg")!
        
        let downloadPublihser = DownloadOperation(url: url).$outputImage
        let blurPublisher = downloadPublihser
            .map{ BlurOperation(image: $0 ?? UIImage(named: "nature")!).$outputImage }
            
        Publishers.Zip(downloadPublihser, blurPublisher)
            .sink(receiveValue: {
                $1.receive(on: RunLoop.main)
                    .sink(receiveValue: { image in
                            image
                            self.image = image
                    }
                )
                .store(in: &self.subscriptions)
            })
            .store(in: &subscriptions)
        
    }
}

class DownloadOperation {
    @Published var outputImage: UIImage?
    var subscriptions = Set<AnyCancellable>()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        URLSession.shared.dataTaskPublisher(for: self.url)
            .print()
            .map({ UIImage(data:$0.data)})
            .replaceError(with: UIImage(named: "nature"))
            .assign(to: &self.$outputImage)
//            .sink { image in
//                image
//                self.outputImage = image
//            }
            //.store(in: &subscriptions)
    }
    
    func download() -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: self.url)
            .map({ UIImage(data:$0.data)})
            .replaceError(with: UIImage(named: "nature"))
            .eraseToAnyPublisher()
    }
    
}

class BlurOperation {
    @Published  var outputImage: UIImage?
    var inputImage: UIImage
    
    init(image: UIImage) {
        self.inputImage = image
        DispatchQueue.global(qos: .userInteractive).async {
            let blurImage = self.inputImage.applyBlurWithRadius(10)
            self.outputImage = blurImage
        }
    }
}


let vm = ViewModel()
var subscriptions = Set<AnyCancellable>()
    
vm.$image
    //.receive(on: RunLoop.main)
    .sink(receiveValue: {image in
    image
    let _ = image
}).store(in: &subscriptions)
vm.downloadImage()

//: [Next](@next)
