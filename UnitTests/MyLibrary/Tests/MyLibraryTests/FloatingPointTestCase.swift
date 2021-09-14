//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/06/21.
//
import XCTest
import MyLibrary

final class FloatingPointCase: XCTestCase {
    func test_isInteger() {
        XCTAssert(1.0.isInteger)
        XCTAssertFalse((1.1 as CGFloat).isInteger)
    }
}
