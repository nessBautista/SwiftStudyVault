//: [Previous](@previous)

import Foundation
import Combine

public enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbiden
    case notFound
    case unknown
}

extension URLSession {
    func fetch(request: URLRequest) -> AnyPublisher<Data, NetworkError>{
        self.dataTaskPublisher(for: request)
            .mapError({ error in
                return NetworkError.unknown
            })
            .map({ (data, response) in

                return data
            }).eraseToAnyPublisher()
    }
    
    func fetch02(request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        self.dataTaskPublisher(for: request)
          
            .tryMap { (data: Data, response: URLResponse) in
                if let response = response as? HTTPURLResponse {
                    let code = response.statusCode
                    if code == 200 {
                        return data
                    }
                    
                } else {
                    throw NetworkError.unknown
                }
                return data
            }
            .mapError({ error in
                return NetworkError.unknown
            })
            .eraseToAnyPublisher()
    }
    
    //Try map always returns a Swift.Error, you need mapError to transform to a custom error
    func requestPublisher03(request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        self.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                if let response = response as? HTTPURLResponse {
                    let code = response.statusCode
                    if code == 200 {
                        return data
                    }
                    
                } else {
                    throw NetworkError.unknown
                }
                return data
            }
            .mapError({ error in
                return NetworkError.unknown
            })
            .eraseToAnyPublisher()
    }
    
    func requestPublisher04(request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return self.dataTaskPublisher(for: request)
            .mapError { (error) in
                return NetworkError.unknown
            }
            .flatMap { (data: Data, response: URLResponse) -> CurrentValueSubject<Data, NetworkError> in
                let currentValueSubject = CurrentValueSubject<Data, NetworkError>(data)
                return currentValueSubject
            }.eraseToAnyPublisher()
    }
}
protocol Transporter {
    func fetch(request: URLRequest) -> AnyPublisher<Data,NetworkError>
}

print("run")
// Check the use of flatMap below

//WeatherStation may well be a struct containing all the request Methods
public struct WeatherStation {
    public let stationID: String
}

var weatherPublisher = PassthroughSubject<WeatherStation, URLError>()

let cancellable: Cancellable = weatherPublisher.flatMap { station -> URLSession.DataTaskPublisher in
    let url = URL(string:"https://weatherapi.example.com/stations/\(station.stationID)/observations/latest")!
    return URLSession.shared.dataTaskPublisher(for: url)
}
.sink(
    receiveCompletion: { completion in
        // Handle publisher completion (normal or error).
        print(completion)
    },
    receiveValue: { val in
        // Process the received data.
        print(val)
    }
 )

weatherPublisher.send(WeatherStation(stationID: "KSFO")) // San Francisco, CA
weatherPublisher.send(WeatherStation(stationID: "EGLC")) // London, UK
weatherPublisher.send(WeatherStation(stationID: "ZBBB")) // Beijing, CN



//: [Next](@next)
