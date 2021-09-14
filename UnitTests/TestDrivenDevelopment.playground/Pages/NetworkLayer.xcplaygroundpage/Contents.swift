//: [Previous](@previous)

import Combine
import Foundation
import XCTest

protocol Transfer {
    func fetch(url: URL)->AnyPublisher<Data, Error>
}

class MockNetworkRouter: Transfer {
    func fetch(url: URL)->AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data, Error>(Data())
        return publisher.eraseToAnyPublisher()
    }
}

class NetworkLayerTests: XCTestCase {
    var subscriptions: Set<AnyCancellable>!
    var validURL: URL!
    var sut : MockNetworkRouter!
    override func setUp() {
        super.setUp()
        subscriptions =  Set<AnyCancellable>()
        validURL = URL(string: "https://www.google.com/")!
        sut = MockNetworkRouter()
    }
    
    override func tearDown() {
        subscriptions = nil
        validURL = nil
        sut = nil
        super.tearDown()
    }
    
    func testNetworkRouter_whenFetch_returnsAnyPublisherOfTypeData() {
        //when
        let publisher = sut.fetch(url: validURL)
        XCTAssertTrue((publisher as AnyObject) is AnyPublisher<Data, Error>)
    }
    
    func testNetworkRouter_whenFetch_publisherEmitsData(){
        //given
        let expectation = expectation(description: "Fetch a valid URL returns Data")
        var result: Data?
        
        //when
        sut.fetch(url: validURL)
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                defer {expectation.fulfill()}
                result = response
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
        //Then
        XCTAssertNotNil(result)
    }
}

NetworkLayerTests.defaultTestSuite.run()
//: [Next](@next)
