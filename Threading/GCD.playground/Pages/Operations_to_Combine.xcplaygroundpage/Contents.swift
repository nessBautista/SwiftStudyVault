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
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: defaultImage)
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(err) = completion {
                    print("Retrieving data failed with error \(err)")
                }
            })
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
            .store(in: &disposables)
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
