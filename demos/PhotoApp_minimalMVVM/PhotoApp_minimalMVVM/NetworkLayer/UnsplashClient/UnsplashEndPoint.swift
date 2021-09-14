//
//  UnsplashEndPoint.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
enum UnsplashEndPoint: EndPointType {
    case getPhotos(page:Int, perPage:Int, orderBy:String?)
    
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
    
    var parameters: [String : Any]? {
        switch self {
        case .getPhotos(let page, let perPage,let orderBy):
            var params:[ String: Any] = [:]
            params["page"] = page
            params["per_page"] = perPage
            params["order_by"] = orderBy
            return params
        }
    }
    
}
