//
//  ViewModel01.swift
//  AsyncCollections
//
//  Created by Nestor Hernandez on 02/06/21.
//

import Foundation
import UIKit

protocol ViewModel01Protocol {
    //UI Elements
    var models:[ListItem] {get set}
    var onModelsDidLoad: (([ListItem], IndexPath) -> Void)? {get set}
    
    //User Actions
    func fetchImage(idx: IndexPath)
}

class ViewModel01 {
    //Dependencies
    let networkRouter: NetworkLayer = NetworkLayer01()
    
    //UI Elements
    var models:[ListItem] = []
    //Because I'm not using Reactive Frameworks, I can use other types of communication for binding
    var onModelsDidLoad: (([ListItem], IndexPath) -> Void)?
    
    init() {
        for url in urls.compactMap({URL(string: $0)}){
            self.models.append(ListItem(url: url))
        }
    }
    
    lazy var urls:[String] = {
        //Extrac urls from plist file
        guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              let serialUrls = serial as? [String] else {
          print("Something went horribly wrong!")
          return []
        }
        return serialUrls
    }()
    
    func fetchImage(idx: IndexPath) {
        let model = models[idx.row]
        self.networkRouter.fetch(url: model.url) {  [weak self] data, error in
            guard error == nil else { return }
            if let rawData = data {
                self?.models[idx.row].rawImage = rawData
                DispatchQueue.main.async {
                    self?.onModelsDidLoad?(self?.models ?? [], idx)
                }
            }
        }
    }
}

// We can also explore different types of interaction with the Network Layer
protocol NetworkLayer {
    func fetch(url: URL, completion: @escaping(_ image: Data?, _ error: Error?) -> Void)
}

class NetworkLayer01: NetworkLayer {
    func fetch(url: URL, completion: @escaping(_ image: Data?, _ error: Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            //Error handling
            guard let response = response as? HTTPURLResponse else {
                completion(nil, AppError.networkError)
                return
            }
            guard response.statusCode == 200 else {
                completion(nil, AppError.networkError)
                return
            }
            guard let rawData = data else {
                completion(nil, AppError.networkError)
                return
            }
            completion(rawData, nil)
        }.resume()
    }
}
