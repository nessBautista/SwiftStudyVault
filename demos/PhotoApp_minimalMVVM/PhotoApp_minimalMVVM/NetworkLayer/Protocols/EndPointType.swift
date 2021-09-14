//
//  EndPointType.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
import OrderedCollections

protocol EndPointType {
    var baseURL: URL { get }
    var endPoint: String { get }
    var urlRequest: URLRequest { get }
    var clientID: String { get }
    var encoder: EncoderType { get }
    var parameters: OrderedDictionary<String, Any>? { get }
    var headers:[String: String] { get }
}

