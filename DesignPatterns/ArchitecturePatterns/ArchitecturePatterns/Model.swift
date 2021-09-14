//
//  Model.swift
//  ArchitecturePatterns
//
//  Created by Nestor Hernandez on 28/05/21.
//

import Foundation

struct Model {
    static let textKey = "text"
    static let textDidChange = Notification.Name("textDidChange")
    
    var value: String {
        didSet {
            NotificationCenter.default.post(name: Model.textDidChange,
                                            object: self,
                                            userInfo: [Model.textKey : value])
        }
    }

    
    init(value: String) {
        self.value = value
    }
}
