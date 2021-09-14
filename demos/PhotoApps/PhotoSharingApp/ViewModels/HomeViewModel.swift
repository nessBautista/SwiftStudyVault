//
//  HomeViewModel.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 13/06/21.
//

import Foundation
import Combine
import UIKit

protocol HomeViewModelProtocol {
    associatedtype ViewModel: FeedItemViewModelProtocol
    // UI
    var homeCollection: CurrentValueSubject<[ViewModel], Never> {get set}
    //var reloadPublisher:PassthroughSubject<IndexPath, Never> {get set}
    // Layer Connections
    var networkClient: NetworkLayerProtocol { get }
    
    // Actions
    func loadFeedItems()
    func fetchImage(idx: IndexPath)
    func cancelFetchImage(idx: IndexPath)
}

class HomeViewModel: HomeViewModelProtocol {
    typealias ViewModel = FeedItemViewModel
    var homeCollection: CurrentValueSubject<[ViewModel], Never>
    var reloadPublisher = PassthroughSubject<IndexPath, Never>()
    var networkClient: NetworkLayerProtocol

    var pageNumber: Int = 1
    private var subscriptions = Set<AnyCancellable>()
    private var imageDownloads = [String: AnyCancellable]()
    init(collection: [ViewModel],
         client: NetworkLayerProtocol = UnsplashClient()) {
        self.networkClient = client
        self.homeCollection = CurrentValueSubject<[ViewModel], Never>(collection)
        
    }
    
    func loadFeedItems() {
        let endPoint =  UnsplashEndpoint.photos(page: self.pageNumber,
                                                perPage: self.itemsPerPage,
                                                orderBy: nil)
        let publisher: AnyPublisher<[Photo], UnsplashError> = networkClient
                                                             .fetch(endpoint: endPoint)
        publisher
            .map { photos -> [ViewModel] in
                let feedItems = photos.map({ViewModel($0)})
                return feedItems
            }
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error)
                case .finished:
                    self.pageNumber += 1
                }
                print(completion)
            } receiveValue: { homePhotoArray in
                self.homeCollection.value.append(contentsOf: homePhotoArray)
            }
            .store(in: &subscriptions)
    }
    
    func fetchImage(idx: IndexPath) {
        //Check item exist
        guard let item = self.item(at: idx.row) else {return}
        //Check image is not downloaded
        guard item.image == nil else { return }
        //Check download is not in progress
        guard imageDownloads[item.id] == nil else { return }
        
        //proceed to download
        guard let url = URL(string: item.photo.urls[UnsplashURL.full.rawValue] ?? String()) else { return }
        let subscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            //.receive(on: DispatchQueue.main)
            .sink { completion in
                print("--->\(idx.row) image download:\(completion)")
                self.imageDownloads[item.id] = nil
            } receiveValue: { [weak self] (data: Data, response: URLResponse) in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                      code == 200 else { return }
                print(Thread.current)
                //Update item
                self?.homeCollection.value[idx.row].rawImage = data
                self?.homeCollection.value[idx.row].loaded = true
                self?.homeCollection.value[idx.row].image = UIImage(data: data)
                //self?.reloadPublisher.send(idx)
            }
        //Add download register
        self.imageDownloads[item.id] = subscription
    }
    
    func cancelFetchImage(idx: IndexPath) {
        guard let item = self.item(at: idx.row) else {return}
        self.imageDownloads[item.id] = nil
    }
}

extension HomeViewModel: PageableArray {
    var items: [ViewModel] {
        get {
            homeCollection.value
        }
        set {
            homeCollection.send(newValue)
        }
    }
    
    var hasNextPage: Bool {
        return true
    }
    
    var hasPreviousPage: Bool {
        self.pageNumber > 1
    }
    
    var itemsPerPage: Int {
        return 20
    }
    
    func item(at index: Int) -> ViewModel? {
        self.homeCollection.value[safe: index]
    }
    
    func replaceItem(at index: IndexPath, with item: ViewModel) {
        guard index.row < self.homeCollection.value.count else
        { return }
        self.homeCollection.value[index.row] = item
    }
}

protocol PageableArray {
    associatedtype ViewModel
    var items:[ViewModel] {get set}
    var hasNextPage: Bool {get}
    var hasPreviousPage:Bool {get}
    var itemsPerPage: Int {get}
    var pageNumber: Int {get set}
    
    func item(at index: Int) -> ViewModel?
    mutating func replaceItem(at index: IndexPath, with item: ViewModel)
}

extension Collection where Indices.Iterator.Element == Index {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

