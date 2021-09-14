//: [Previous](@previous)

import Foundation
import UIKit

func getURLs() -> [URL] {
    guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
          let contents = try? Data(contentsOf: plist),
          let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
          let serialUrls = serial as? [String] else {
            
        print("Something went horribly wrong!")
        return []
    }
    let urls = serialUrls.compactMap { URL(string: $0) }
    
    return urls
}

let urls = getURLs()

func getImage(_ url: URL,
              completion: @escaping(Result<UIImage, Error>)->()) {
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data,
           let image = UIImage(data: data) {
            completion(.success(image))
        } else {
            completion(.failure(error!))
        }
    }.resume()
}

// Download a group of images, when ALL the images have been downloaded, print: "ALL DONE", show the first image
func asyncGroupWrapper(url:URL,
                       group: DispatchGroup,
                         runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
                         completionQueue: DispatchQueue = .main,
                         completion: @escaping(Result<UIImage, Error>) ->()) {
    group.enter()
    runQueue.async {
        getImage(url) { result in
            defer { group.leave() }
            completion(result)
        }
    }
}

let group = DispatchGroup()
var images: [UIImage] = []
for url in urls {
    asyncGroupWrapper(url: url, group: group) { result in
        print("dowloaded: \(result)")
        if case .success(let image) = result {
            images.append(image)
        }
    }
}
group.notify(queue: DispatchQueue.main) {
    print("ALL DONE")
    images[0]
}

//: [Next](@next)
