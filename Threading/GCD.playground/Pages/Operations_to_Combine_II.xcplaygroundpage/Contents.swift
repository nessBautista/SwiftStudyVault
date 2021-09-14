//: [Previous](@previous)

import Foundation
import SwiftUI
import PlaygroundSupport
import Combine

struct ImageListView: View {
    var url: URL
    var body: some View {
        ImageView(model: ImageViewModel(url: url))
    }
}

struct ImageView: View {
    @ObservedObject var viewModel: ImageViewModel
    private let defaultImage = UIImage(named: "nature")!
    
    init(model: ImageViewModel) {
        self.viewModel = model
        self.viewModel.fetchImage()
    }
    
    var body: some View {
        Image(uiImage: viewModel.image ?? defaultImage)
            .resizable()
            .frame(width: 275, height: 275, alignment: .center)
    }
}

class ImageViewModel: ObservableObject {
    let url: URL
    @Published public var image: UIImage?
    private let defaultImage = UIImage(named: "nature")!
    private var disposables = Set<AnyCancellable>()
    
    init(url: URL) {
        self.url = url
    }
    
    public func fetchImage() {
        let downloadPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: defaultImage)

        let filterPublisher = downloadPublisher.map({ TiltShiftOperation(inputImage: $0 ?? self.defaultImage).$outputImage})

        Publishers.Zip(downloadPublisher, filterPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveValue: {
                $1//.receive(on: RunLoop.main)
                    .sink(receiveValue: {
                        self.image = $0 ?? self.defaultImage
                    })
                    .store(in: &self.disposables)
            })
            .store(in: &disposables)
    }
//    public func fetchImage() {
//        let downloadPublisher = URLSession.shared.dataTaskPublisher(for: url)
//            .map { UIImage(data: $0.data) }
//            .replaceError(with: defaultImage)
//
//        let filterPublisher = downloadPublisher.map({ TiltShiftOperation(inputImage: $0 ?? self.defaultImage)})
//
//        Publishers.Zip(downloadPublisher, filterPublisher)
//            .receive(on: RunLoop.main)
//            .sink(receiveValue: {
//                $1.$outputImage//.receive(on: RunLoop.main)
//                    .sink(receiveValue: {
//                        self.image = $0 ?? self.defaultImage
//                    })
//                    .store(in: &self.disposables)
//            })
//            .store(in: &disposables)
//    }
    
}

// Notice how you change from an Operation to an Observable Object
final class TiltShiftOperation: ObservableObject {
    @Published var outputImage: UIImage?
    private static let context = CIContext()
    var inputImage: UIImage?
    
    init(inputImage: UIImage) {
        self.inputImage = inputImage
        // You are still using the DispatchQueue to compute out of the main thread
        DispatchQueue.global(qos: .userInteractive).async {
            self.filterImage(image: self.inputImage!)
        }
    }
    
    func filterImage(image: UIImage) {
        guard let filter = TiltShiftFilter(image: image),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }
        
        let fromRect = CGRect(origin: .zero, size: inputImage!.size)
        guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
            print("No image generated")
            return
        }
        // Once you finish you're returning to the main thread
        DispatchQueue.main.async {
            self.outputImage = UIImage(cgImage: cgImage)
            print(">>> filterImage done <<<")
        }
    }
}

let url = URL(string: "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466780-jpeg.jpg")!

//Testing single combine subscription
var subscriptions = Set<AnyCancellable>()
let viewModel = ImageViewModel(url: url)
viewModel.$image.sink { image in
    if let output = image {
        print("Image Did finished processing")
        output
    }
}.store(in: &subscriptions)
viewModel.fetchImage()

//Testing SwiftUI view structs
PlaygroundPage.current.setLiveView(ImageListView(url: url))
//: [Next](@next)
