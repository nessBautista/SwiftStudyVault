//
//  ErrorHandling.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import Foundation
enum NetworkError: Error {
    case serverError(Int)
    case clientError(Int)
    case decoding
    case unknown
    
    init(code: Int){
        switch code {
        case (400..<500):
            self = .clientError(code)
        case (500..<600):
            self = .serverError(code)
        default:
            self = .unknown
        }
    }
}

class ErrorHandler {
    static func handle(_ error: Error, response: HTTPURLResponse?) -> NetworkError {
        guard let code = response?.statusCode else {return .unknown}
        return NetworkError(code: code)
    }
}

