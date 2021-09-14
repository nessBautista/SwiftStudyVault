//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/06/21.
//

public extension FloatingPoint {
    var isInteger: Bool {rounded() == self}
}
