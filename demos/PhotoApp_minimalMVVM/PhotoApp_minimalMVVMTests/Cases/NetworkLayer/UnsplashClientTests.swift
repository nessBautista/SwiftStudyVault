//
//  UnsplashClientTests.swift
//  PhotoApp_minimalMVVMTests
//
//  Created by Nestor Hernandez on 14/07/21.
//

import XCTest
@testable import PhotoApp_minimalMVVM

var sut: UnsplashClient!
var mockSession: MockURLSession!
var endpoint: UnsplashEndPoint!
var endpointURL: URL {
    return endpoint.urlRequest.url ?? URL(string: "https://example.com")!
}

class UnsplashClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        endpoint = .getPhotos(page: 1, perPage: 10, orderBy: nil)
        sut = UnsplashClient(session: mockSession)
    }
    
    private func givenGetPhotosEndpoint(){
        endpoint = .getPhotos(page: 1, perPage: 10, orderBy: nil)
    }
    
    private func whenGetPhotos(data: Data? = nil,
                               statusCode: Int = 200,
                               error: Error? = nil)
                                -> (calledCompletion: Bool,
                                    receivedPhotos: [Photo]?,
                                    receivedError: Error?) {
        givenGetPhotosEndpoint()
        let response = HTTPURLResponse(url: endpointURL,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        var calledCompletion = false
        var receivedPhotos: [Photo]? = nil
        var receivedError: Error? = nil
        let mockTask = sut.fetch(endpoint: endpoint,
                                 model: [Photo].self) { result in
            defer { calledCompletion = true }
            switch result {
            case .success(let photos):
                receivedPhotos = photos
            case .failure(let error):
                receivedError = error
            }
            
        } as! MockURLSessionDataTask
        mockTask.completionHandler(data, response, error)
        return (calledCompletion, receivedPhotos, receivedError)
    }
    
    override func tearDown() {
        mockSession = nil
        endpoint = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization
    func testUnsplashClient_whenInit_sessionIsSet(){
        XCTAssertEqual(sut.session, mockSession)
    }
    
    // MARK: - API CALLS
    /* For each API endpoint you need to test that:
     1. You are calling the right URL
     2. Handling Error responses
     3. Deserializing models on success
     4. Handling Invalid Responses
     */
    
    func testUnsplashClient_getPhotos_callsExpectedURL() throws {
        //given
        givenGetPhotosEndpoint()
        //When
        let dataTask = sut.fetch(endpoint: endpoint,
                                 model: [Photo].self) { _ in } as! MockURLSessionDataTask
        //then
        let expectedURL = try XCTUnwrap(endpoint.urlRequest.url)
        XCTAssertEqual(dataTask.url, expectedURL)
    }
    
    func testUnsplashClient_getPhotos_callsResume(){
        //given
        givenGetPhotosEndpoint()
        //When
        let dataTask = sut.fetch(endpoint: endpoint,
                                 model: [Photo].self) { _ in } as! MockURLSessionDataTask
        //then
        XCTAssertTrue(dataTask.calledResume)
    }
    
    func testUnsplashClient_getPhotos_givenResponseStatusCode500CallsCompletionWithServerError() {
        // when
        let result = self.whenGetPhotos(statusCode: 500)
        //then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.receivedPhotos)
        XCTAssertNotNil(result.receivedError)
        XCTAssertEqual(result.receivedError as? UnsplashError, UnsplashError.serverError)
    }
    
    func testUnsplashClient_getPhotos_givenErrorCallsCompletionWithNetworkError() {
        //given
        let expectedError = NSError(domain: "com.UnsplashClientTests", code: 42)
        // when
        let result = whenGetPhotos(statusCode: 200, error: expectedError)
        //then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.receivedPhotos)
        XCTAssertNotNil(result.receivedError)
        XCTAssertEqual(result.receivedError as? UnsplashError, UnsplashError.networkError)
    }
    
}
