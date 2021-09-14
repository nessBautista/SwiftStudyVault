//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/06/21.
//

import Foundation
public extension Sequence {
    var first: Element? {
        self.first{ _ in true}
    }
}

public extension Sequence where Element : AdditiveArithmetic {
    var sum: Element? {
        guard let first = first else {
            return nil
        }
        return dropFirst().reduce(first,+)
    }
}
