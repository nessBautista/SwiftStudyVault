//
//  UnsplashClient.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
enum UnsplashError: Error {
    case serverError
    case networkError
    case serializationError
}

class UnsplashClient {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetch<Model: Codable>(endpoint: UnsplashEndPoint,
                               model: Model.Type,
                               completion: @escaping(Result<Model, Error>) -> Void)
                             -> URLSessionDataTask {
      
        let task = session.dataTask(with: endpoint.urlRequest.url!) {data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(UnsplashError.serverError))
                return
            }
            if  error != nil {
                completion(.failure(UnsplashError.networkError))
            }
            
        }
        task.resume()
        return task
    }
}
