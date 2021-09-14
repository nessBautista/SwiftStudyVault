//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 12/06/21.
//

import UIKit
import Combine
class ViewController: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = UnsplashClient()
        
        let photosPublisher: AnyPublisher<[Photo], UnsplashError> = client.fetch(endpoint: UnsplashEndpoint.photos(page: 1, perPage: 20, orderBy: nil))
        
        photosPublisher.sink { completion in
            print(completion)
        } receiveValue: { photos in
            photos.forEach({print($0.description)})
        }.store(in: &subscriptions)
    }


}

