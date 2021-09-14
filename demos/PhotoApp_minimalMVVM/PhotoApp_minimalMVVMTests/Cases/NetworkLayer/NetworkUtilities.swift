//
//  NetworkUtilities.swift
//  PhotoApp_minimalMVVMTests
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
import OrderedCollections
class NetworkUtilities {
    class func getQueryItems(from url: URL)-> [URLQueryItem]? {
        
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        return queryItems
    }
    class func verify(queryItems: [URLQueryItem], contain parameters:OrderedDictionary<String, Any>) -> Bool {
        for item in queryItems {
            if parameters[item.name] == nil {
                return false
            }
        }
        return true
    }
}
