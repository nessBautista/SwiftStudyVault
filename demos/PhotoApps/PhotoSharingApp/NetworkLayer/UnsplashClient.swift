//
//  UnsplashClient.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 12/06/21.
//

import Foundation
import Combine
enum UnsplashEndpoint: EndPointType {
    static let UnsplashAPIKey = "TVaxbYcLeYTX5HSSlOASUAuZyQ_StH1sfsxehsWL_Oc"
    case photos(page: Int, perPage: Int, orderBy:String? = "latest")
    case photo(id: Int)
    case randomPhoto
    case statisitcs(id: Int)
    case download(id: Int)
    case update(id: Int)
    case like(id: Int)
    case unlike(id: Int)
    
    var baseURL: URL {
        return URL(string:"https://api.unsplash.com/")!
    }
    
    var path: String {
        switch self {
        case .photos(page: _, perPage: _, orderBy: _):
            return "photos"
        case .photo(id: let id):
            return "photos/\(id)"
        default:
            return String()
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .photos(page: _, perPage: _, orderBy: _):
            return .get
        case .photo(id: _):
            return .get
        default:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization":"Client-ID \(UnsplashEndpoint.UnsplashAPIKey)"]
    }
    
    var request: URLRequest {
        switch self {
        case .photos(page: let page, perPage: let perPage, orderBy: let orderBy):
            //Prepare parameters
            var params = [String:Any]()
            params["page"] = page
            params["per_page"] = perPage
            params["order_by"] = orderBy
            params["client_id"] = UnsplashEndpoint.UnsplashAPIKey
            //Prepare URL
            let url = self.baseURL.appendingPathComponent(self.path)
            //Prepare Encoding
            let encoder: EncoderType = .url
            var request = URLRequest(url: url)
            return encoder.encode(request: &request, params: params)
        default:
            return URLRequest(url: self.baseURL)
        }
    }
}

class UnsplashClient: NetworkLayerProtocol {
    func fetch<Element: Decodable>(endpoint: EndPointType) -> AnyPublisher<Element, UnsplashError> {
        let request = endpoint.request
        return URLSession.shared.fetch(request)
            .decode(type: Element.self, decoder: JSONDecoder())
            .mapError { error in
                return UnsplashError.unknown
            }
            .eraseToAnyPublisher()
    }
}

extension URLSession: Transport {
    func fetch(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else { throw UnsplashError.unknown }
                guard response.statusCode == 200 else { throw UnsplashError.unknown }
                return data
            }
            .mapError { error in
                return UnsplashError.unknown
            }
            .eraseToAnyPublisher()
    }
}
