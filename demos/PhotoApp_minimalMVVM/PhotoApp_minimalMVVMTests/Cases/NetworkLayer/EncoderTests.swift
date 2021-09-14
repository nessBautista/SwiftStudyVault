//
//  EncoderTests.swift
//  PhotoApp_minimalMVVMTests
//
//  Created by Nestor Hernandez on 13/07/21.
//

import XCTest
@testable import PhotoApp_minimalMVVM
import OrderedCollections
class EncoderTests: XCTestCase {

    var sut: EncoderType!
    override func setUp() {
        sut = UnsplashEncoder.url
        super.setUp()
    }
    
    func givenURLEncoder(){
        sut = UnsplashEncoder.url
    }
    
    func givenJSONEncoder(){
        sut = UnsplashEncoder.json
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    //MARK: - Utilities
    func verify(parameters: [String: Any], exists inQuery:[URLQueryItem]){
        for item in inQuery {
            XCTAssertNotNil(parameters[item.name])
        }
    }
    
    //MARK: - Initial Configuration
    func testEncoder_subscribesToEncoderType(){
        XCTAssertTrue((sut as AnyObject) is EncoderType)
    }
    
    func testURLEncoder_encodesParamsIntoURL(){
        //given
        givenURLEncoder()
        let parameters: OrderedDictionary<String, Any> = ["param1": 1, "param2":2]
        var testRequest = URLRequest(url: URL(string: "https://test.example.com/")!)
        
        //when
        sut.encode(parameters, in: &testRequest)
        
        //then
        let queryItems = NetworkUtilities.getQueryItems(from: testRequest.url!)
        XCTAssertNotNil(queryItems)        
        XCTAssertTrue(NetworkUtilities.verify(queryItems: queryItems!, contain: parameters))
    }

}
