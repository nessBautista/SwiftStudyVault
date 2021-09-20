//: [Previous](@previous)

import Foundation
import Combine

// Utilities
enum NetworkError: Error {
    case APIError(APIError)
    case badRequest
    case unauthorized
    case forbiden
    case notFound
    case unknow
}

enum APIError {
    case maintainance
    case deprecated
}

/*
 First lets define the one basic architecutre in 3 parts
    1. The Transport Layer: This is the layer sending the request and receiving the data. It validates errors from server and returns a raw Data type
    2. Network Router: this is the one receiving the parameters, endpoint, url, etc. And returning the expected Model Type.
    3. Finally we have the ViewModel Using a dependency of Network Router to fulfill a business rule requirement
 
 */

// The Transport (With Combine)
protocol Transport {
    func fetch(_ request: URLRequest) -> AnyPublisher<Data, NetworkError>
}

extension URLSession: Transport {
    func fetch(_ request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        self.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.unknow
                }
                guard 200..<300 ~= response.statusCode else {
                    throw self.getApiError(statusCode: response.statusCode)
                }
                return data
                
            }
            .mapError { error in
                return NetworkError.unknow
            }
            .eraseToAnyPublisher()
    }
    
    private func getApiError(statusCode: Int) -> NetworkError {
        //TODO: Check API Error list and write a switch
        return NetworkError.unknow
    }
}

// The Network Router
protocol EndpointType {
    associatedtype Output: Decodable
    var baseURL: URL { get }
    var endpoint: String { get }
    var parameters: [String: Any]? { get }
}

//Associated type 'Output' can only be used with a concrete type or generic parameter base
//protocol Test{
//    func fetch(_ endPoint: EndPointType) -> AnyPublisher<EndpointType.Output, NetworkError>
//}

protocol NetworkRouter {
    func fetch<EndPoint: EndpointType>(_ endPoint: EndPoint) -> AnyPublisher<EndPoint.Output, NetworkError>
}

class UnsplashClient: NetworkRouter {
    let session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<EndPoint: EndpointType>(_ endPoint: EndPoint) -> AnyPublisher<EndPoint.Output, NetworkError> {
        let request = self.buildRequest(endPoint)
        return session.fetch(request)
            .tryMap { data -> EndPoint.Output in
                if let model = try? JSONDecoder().decode(EndPoint.Output.self, from: data) {
                    return model
                }
                throw NetworkError.unknow
            }
            .mapError { error in
                return NetworkError.unknow
            }
            .eraseToAnyPublisher()
    }
    
    private func buildRequest<EndPoint: EndpointType>(_ endPoint: EndPoint) -> URLRequest {
        // TODO form url request
        let urlRequest = URLRequest(url: endPoint.baseURL)
        
        return urlRequest
    }
    
}

// ViewModel
protocol HomeViewModelProtocol {
    // UI Elements
    var photos: CurrentValueSubject<[Photo], Error> { get set }
    //User actions
    func getHomeFeed()
}

class HomeViewModel: HomeViewModelProtocol {
    var photos = CurrentValueSubject<[Photo], Error>([])
    var subscriptions = Set<AnyCancellable>()
    var networkRouter: NetworkRouter
    
    init(netRouter: NetworkRouter) {
        self.networkRouter = netRouter
    }
    
    func getHomeFeed() {
        self.networkRouter.fetch(UnsplashPhotos())
        
    }
}

struct UnsplashPhotos: EndpointType {
       
    typealias Output = [Photo]
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    var endpoint:String {
        return "/photos"
    }
    var httpMethod: String {
        return "GET"
    }
    var parameters: [String: Any]?
}

func testGeneric<T:Codable>(param: T) {
    print(param)
}
print("ok")
testGeneric(param: "Hello")
//: [Next](@next)
