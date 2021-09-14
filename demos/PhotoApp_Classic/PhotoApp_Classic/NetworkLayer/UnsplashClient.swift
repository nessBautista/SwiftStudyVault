//
//  UnsplashClient.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import Foundation

enum UnsplashEndPoint<Model: Decodable>: EndPointType , Hashable{
    typealias M =  Model
    
    case photos(page: Int, perPage: Int, orderBy: String? = "latest")
    case photo(id: Int)
    case searchPhoto(query: String, page: Int, perPage: Int)
    
    
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com/")!
    }
    
    var endPointPath: String {
        switch self {
        case .photos(page: _, perPage: _, orderBy: _):
            return "photos"
        case .photo(let id):
            return "photos/\(id)"
        case .searchPhoto(query: _, page: _, perPage: _):
            return "/search/photos"
        }
    }
    
    var enconder: EncoderType {
        switch self {
        case .photos(page: _, perPage: _, orderBy: _):
            return EncoderType.url
        case .photo(id: _):
            return EncoderType.url
        case .searchPhoto(query: _, page: _, perPage: _):
            return EncoderType.url
        }
    }
    
    var request: URLRequest {
        switch self {
        case .photos(let page, let perPage , let orderBy):
            let url = self.baseURL.appendingPathComponent(self.endPointPath)
            var params = [String:Any]()
            params["page"] = page
            params["per_page"] = perPage
            params["order_by"] = orderBy
            params["client_id"] = "TVaxbYcLeYTX5HSSlOASUAuZyQ_StH1sfsxehsWL_Oc"
            let request = enconder.encode(url: url, parameters: params)
            
            return request
        case .searchPhoto(let query, let page, let perPage):
            let url = self.baseURL.appendingPathComponent(self.endPointPath)
            var params = [String:Any]()
            params["query"] = query
            params["page"] = page
            params["per_page"] = perPage
            params["client_id"] = "TVaxbYcLeYTX5HSSlOASUAuZyQ_StH1sfsxehsWL_Oc"
            let request = enconder.encode(url: url, parameters: params)
            return request
        default:
            return URLRequest(url: baseURL)
        }
    }
}

class UnsplashClient: NetworkRouter {
    let networkQueue = DispatchQueue(label: "NetworkQueue")
    let unsplashQueue = DispatchQueue(label: "UnplashAPI", attributes: .concurrent)
    var requestRegister: Set<Int> = []
    
    func fetch<E:EndPointType>(endpoint: E,
                               completion: @escaping (Result<E.M, NetworkError>) -> ()) {
        
        networkQueue.async {
            //print("------------start request in networkQueue in thread: \(Thread.current)")
            let request = endpoint.request
            let requestId = endpoint.hashValue
            
            
            guard self.canContinueWithRequest(endpoint: requestId) == true else {
                //print("-------->NetworkQueue Found Duplicated: \(Thread.current)")
                return
            }
            //print("-------->NetworkQueue Modified Register: \(Thread.current)")
            self.willProceedeWithRequest(endpoint: requestId)
            
            
            URLSession.shared.fetch(request) {[weak self] result in
                guard let self = self else { return }
                defer {
                        //Write to register
                    //print("-------->Unregister in: \(Thread.current)")
                        self.didCompleteRequest(endpoint: requestId)
                }
                //print("-------->URLSession returned in: \(Thread.current)")
                switch result {
                case .success(let rawData):
                    do {
                        let model = try JSONDecoder().decode(E.M.self, from: rawData)
                        completion(.success(model))
                    } catch {
                        completion(.failure(NetworkError.decoding))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
        }
    }
    
}
