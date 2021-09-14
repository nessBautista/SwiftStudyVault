//
//  File.swift
//  
//
//  Created by Nestor Hernandez on 29/06/21.
//

import XCTest
import MyLibrary
final class SequenceTestCase: XCTestCase {
    func test_first() {
        let odds = stride(from: 1, through: 9, by: 2)
        let first = odds.first
        XCTAssertEqual(1,first)
        XCTAssertNil(odds.prefix(0).first)
    }
    
    func test_sum() {
        let threeTwoOne = stride(from: 3, through: 1, by: -1)
        XCTAssertEqual(threeTwoOne.sum, 6)        
        XCTAssertEqual([0.5, 1, 1.5].sum, 3)
        XCTAssertNil(Set<CGFloat>().sum)
    }
}
