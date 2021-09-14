//
//  Encoders.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import Foundation
enum EncoderType: RequestEncoder {
    case json
    case url
    
    func encode(url: URL, parameters: [String: Any]) -> URLRequest {
        switch self {
        case .json:
            return URLRequest(url: url)
        case .url:
            var request = URLRequest(url: url)
            URLEncoder.encode(request: &request, parameters: parameters)
            return request
        }
    }
}

protocol RequestEncoder {
    func encode(url: URL, parameters: [String: Any]) -> URLRequest
}
class URLEncoder {
    static func encode(request: inout URLRequest, parameters: [String: Any]) {
        guard let url = request.url else {return}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            for item in parameters {
                let queryItem = URLQueryItem(name: item.key, value: "\(item.value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
    }
}
