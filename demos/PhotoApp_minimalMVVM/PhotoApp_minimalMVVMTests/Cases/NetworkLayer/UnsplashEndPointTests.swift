//
//  UnsplashEndPointTests.swift
//  PhotoApp_minimalMVVMTests
//
//  Created by Nestor Hernandez on 13/07/21.
//

import XCTest
@testable import PhotoApp_minimalMVVM

class UnsplashEndPointTests: XCTestCase {

    var sut: EndPointType!
    var encodedRequest: URLRequest!
    override func setUp() {
        super.setUp()
        sut = UnsplashEndPoint.getPhotos(page: 0, perPage: 0, orderBy: nil)
        encodedRequest = sut.urlRequest
    }
    
    func givenGetPhotosEndPoint() {
        sut = UnsplashEndPoint.getPhotos(page: 1, perPage: 20, orderBy: nil)
    }
    
    override func tearDown() {
        encodedRequest = nil
        sut = nil
        super.tearDown()
    }
    
    //MARK: - Initial Configuration
    func testUnsplashEndPoint_subscribesToEndPoint(){
        XCTAssertTrue((sut as AnyObject) is UnsplashEndPoint)
    }
    
    func testUnsplashEndPoint_containsClientID(){
        XCTAssertFalse(sut.clientID.isEmpty)
    }
    
    func testUnsplashEndPoint_whenInit_baseURLIsSet() {
        //given
        let expectedBaseURL = URL(string: "https://api.unsplash.com/")!
        
        //then
        XCTAssertEqual(sut.baseURL.host, expectedBaseURL.host)
        XCTAssertEqual(sut.baseURL, expectedBaseURL)
    }
    
    func testUnsplashEndPoint_baseURLisSecure() {
        XCTAssertEqual(sut.baseURL.scheme, "https")
    }
    
    func testUnsplashEndPoint_requestContainsHeaders()  {
        XCTAssertNotNil(encodedRequest.allHTTPHeaderFields)
    }
    
    func testUnsplashEndPoint_headersContainsCliendId(){
        XCTAssertNotNil(encodedRequest.value(forHTTPHeaderField:"Authorization"))
    }
    
    //MARK: - Unsplash EndPoints - Get Photos
    func testUnplashEndPoint_getPhotos_matchAPIConfiguration(){
        //given
        givenGetPhotosEndPoint()
        let expectedEndPoint = "photos"
        
        //then
        XCTAssertEqual(sut.endPoint, expectedEndPoint)
        XCTAssertEqual(sut.urlRequest.url?.lastPathComponent, expectedEndPoint)
        XCTAssertTrue(sut.encoder is UnsplashEncoder)
        XCTAssertEqual((sut.encoder as? UnsplashEncoder), .url)
        XCTAssertNotNil(sut.parameters)
    }
    
    func testUnsplashEndPoint_getPhotos_encodesParametersInRequest() throws {
        //given
        givenGetPhotosEndPoint()
        let expectedParams = try XCTUnwrap(sut.parameters)
        let encodedURL = try XCTUnwrap(encodedRequest.url)
        let encodedQueryItems = try XCTUnwrap(NetworkUtilities.getQueryItems(from: encodedURL))

        //then
        XCTAssertTrue(NetworkUtilities.verify(queryItems: encodedQueryItems, contain: expectedParams))
    }

}
