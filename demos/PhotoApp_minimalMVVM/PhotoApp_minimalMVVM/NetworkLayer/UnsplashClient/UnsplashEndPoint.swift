//
//  UnsplashEndPoint.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
import OrderedCollections
enum UnsplashEndPoint {
    case getPhotos(page:Int, perPage:Int, orderBy:String?)
}

extension UnsplashEndPoint: EndPointType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com/")!
    }
    
    var endPoint: String {
        switch self {
        case .getPhotos:
            return "photos"
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .getPhotos(_,_,_):
            let url = baseURL.appendingPathComponent(self.endPoint)
            var request = URLRequest(url: url)
            if let params = self.parameters {
                encoder.encode(params, in: &request)
            }
            request.allHTTPHeaderFields = self.headers
            return request
        }
    }
    
    var clientID: String {
        return "TVaxbYcLeYTX5HSSlOASUAuZyQ_StH1sfsxehsWL_Oc"
    }
    
    var encoder: EncoderType {
        switch self {
        case .getPhotos:
            return UnsplashEncoder.url
        }
    }
    
    var parameters: OrderedDictionary<String, Any>? {
        switch self {
        case .getPhotos(let page, let perPage,let orderBy):
            var params:OrderedDictionary<String, Any> = ["page": page]
            params["per_page"] = perPage
            params["order_by"] = orderBy
            return params
        }
    }
    
    var headers: [String : String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        headers["Authorization"] = "Authorization: Client-ID \(self.clientID)"
        return headers
    }
}
