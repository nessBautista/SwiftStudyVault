//
//  EncoderType.swift
//  PhotoApp_minimalMVVM
//
//  Created by Nestor Hernandez on 13/07/21.
//

import Foundation
import OrderedCollections
protocol EncoderType {
    func encode(_ params: OrderedDictionary<String, Any>, in request: inout URLRequest)
}

