//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/06/21.
//

import Foundation
public struct MyStruct {
    public var text: String?
    
    public init?(text: String? =  nil) {
        guard let initialText = text else { return nil}
        self.text = initialText
    }
}
