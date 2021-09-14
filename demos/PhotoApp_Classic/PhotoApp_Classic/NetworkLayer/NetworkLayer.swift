//
//  NetworkLayer.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import Foundation
protocol EndPointType: Hashable {
    associatedtype M: Decodable
    var baseURL: URL { get }
    var endPointPath: String { get }
    var enconder: EncoderType { get}
    var request: URLRequest { get }
    
}

protocol NetworkRouter: AnyObject {
    // Fetching requires and Endpoint and a Type of result
    func fetch<E: EndPointType>(endpoint:E, completion:@escaping(Result<E.M, NetworkError>) -> ())
    
    // Duplicated Network Request Avoidance
    associatedtype E: Hashable // Register will be a collection of type Set
    var requestRegister: Set<E> { get set }
    func canContinueWithRequest(endpoint: Self.E) -> Bool
    func willProceedeWithRequest(endpoint: Self.E)
    func didCompleteRequest(endpoint:Self.E)
}

extension NetworkRouter {
    func canContinueWithRequest(endpoint: Self.E) -> Bool {
        !requestRegister.contains(endpoint)
    }
    
    func willProceedeWithRequest(endpoint: Self.E) {
        requestRegister.insert(endpoint)
    }
    
    func didCompleteRequest(endpoint:Self.E) {
        requestRegister.remove(endpoint)
    }
}


protocol Transfer {
    func fetch(_ request: URLRequest, completion:@escaping(Result<Data, NetworkError>)->())
}

extension URLSession: Transfer {
    func fetch(_ request: URLRequest, completion:@escaping(Result<Data, NetworkError>)->()) {
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard error == nil else  {
                let netError = ErrorHandler.handle(error!,
                                                   response: response as? HTTPURLResponse)
                completion(.failure(netError))
                return
            }
            if let rawResponse = data {
                completion(.success(rawResponse))
            }
        }
        
        task.resume()
    }
}


