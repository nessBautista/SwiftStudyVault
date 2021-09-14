//
//  NetworkLayerProtocol.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 12/06/21.
//

import Foundation
import Combine
enum UnsplashError: Error {
    case badRequest
    case unknown
}
/**
 HTTP method type classification with String type
 */
public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var headers: [String: String]? { get }
    var request: URLRequest {get}
}

protocol NetworkLayerProtocol {    
    func fetch<Element: Decodable>(endpoint: EndPointType) -> AnyPublisher<Element, UnsplashError>
}

protocol Transport {
    //Receive an URLRequest and outputs a Data response
    func fetch(_ request: URLRequest) -> AnyPublisher<Data, Error>
}
