//
//  HomeViewModel.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 19/06/21.
//

import Foundation
protocol HomeViewModelProtocol {
    associatedtype Network: NetworkRouter
    var networkClient: Network {get}
    //fetch items
    func loadHomeItems()
}

class HomeViewModel: NSObject, PageableArray, HomeViewModelProtocol {
    var networkClient: UnsplashClient
    @objc dynamic var items: [Photo] = []
    
    var hasNext: Bool {
        // True by default as there are no limitations on the API for paging items
        true
    }
    var hasPrevious: Bool {
        pageNumber > 1
    }
    var itemsPerPage: Int {
        20
    }
    var pageNumber: Int = 1
    
    init(networkClient: UnsplashClient = UnsplashClient()) {
        self.networkClient = networkClient
    }
    
    func item(at index: IndexPath) -> Photo? {
        guard index.row < items.count else { return nil }
        return items[index.row]
    }
    
    func replaceItem(at index: IndexPath, with item: Photo) {
        guard index.row < items.count else { return }
        items[index.row] = item
    }
    
    func addItems(_ value: [Photo], from page: Int) {
        self.items.append(contentsOf: value)
        self.pageNumber = page
    }
    
    func loadHomeItems() {
        let endPoint = UnsplashEndPoint<[Photo]>.photos(page: self.pageNumber,
                                                 perPage: self.itemsPerPage,
                                                 orderBy: nil)
        networkClient.fetch(endpoint: endPoint) { result in
            switch result {
            case .success(let photos):
                // Congratulations you have achived success here now send it to the tableview
                self.addItems(photos, from: self.pageNumber + 1)
                print(photos)
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol PageableArray: AnyObject {
    associatedtype Element
    var items: [Element] { get set}
    var hasNext: Bool { get }
    var hasPrevious: Bool { get }
    var itemsPerPage: Int {get}
    var pageNumber: Int {get set}
    
    func item(at index: IndexPath) -> Element?
    func replaceItem(at index: IndexPath, with item: Element)
    func addItems(_ value: [Element], from page: Int)
}
