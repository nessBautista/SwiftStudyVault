//
//  Encoders.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 13/06/21.
//

import Foundation

enum EncoderType: RequestEncoder {
    case url
    case json
    
    func encode(request: inout URLRequest, params:[String:Any]?) -> URLRequest {
        switch self {
        case .url:
            //extract url from request
            guard let url = request.url else {return request}
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let parameters = params {
                urlComponents.queryItems = [URLQueryItem]()
                for (key, value) in parameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)"
                                                    .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                    urlComponents.queryItems?.append(queryItem)
                }
                request.url = urlComponents.url
            }            
            return request
        default:
            return request
        }
    }
}
protocol RequestEncoder {
    func encode(request: inout URLRequest, params:[String:Any]?)-> URLRequest
}
