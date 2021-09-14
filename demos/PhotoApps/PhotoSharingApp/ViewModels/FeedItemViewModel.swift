//
//  FeedItemViewModel.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 14/06/21.
//

import Foundation
import UIKit
import Combine
protocol FeedItemViewModelProtocol: Hashable {
    var photo: Photo {get}
    
    var loaded: Bool {get set}
    
    var userName: String {get}
    
    var location: String  {get}
    
    var rawImage: Data? {get set}
    
    var image: UIImage? {get set}
}

class FeedItemViewModel: Hashable, FeedItemViewModelProtocol, ObservableObject {
    // base model
    var photo: Photo
    
    var id: String {
        return photo.id
    }
    var loaded: Bool = false
    
    var userName: String {
        self.photo.user.username
    }
    
    var location: String {
        self.photo.user.location ?? String()
    }
    
    var rawImage: Data?
    
    @Published var image: UIImage? 
    
    private var subscriptions = Set<AnyCancellable>()
    init(_ photo: Photo) {
        self.photo = photo
    }
    
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        (lhs.id == rhs.id) 
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
protocol ImageDownloader {
    associatedtype M: Hashable
    func fetchImage(_ model: M)
    func cancelfetchImage(_ model: M)
}

extension FeedItemViewModel: ImageDownloader {
    typealias M = Photo
    
    func fetchImage(_ model: M) {
        guard self.image == nil else { return }
        //proceed to download
        guard let url = URL(string: model.urls[UnsplashURL.full.rawValue] ?? String()) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .sink { completion in
                print("-----\(model.id)-imageDownload-->\(completion)")
            } receiveValue: { [weak self] (data: Data, response: URLResponse) in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                      code == 200 else { return }
                self?.image = UIImage(data: data)
            }.store(in: &subscriptions)
    }
    
    func cancelfetchImage(_ model: M) {
        
    }
}
