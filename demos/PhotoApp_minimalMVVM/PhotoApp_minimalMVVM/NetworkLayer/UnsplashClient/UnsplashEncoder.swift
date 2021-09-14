//
//  UnsplashEncoder.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
import OrderedCollections
enum UnsplashEncoder: EncoderType {
    case url
    case json
    
    func encode(_ params: OrderedDictionary<String, Any>, in request: inout URLRequest){
        guard let url = request.url else { return }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)"
                                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
    }
}
