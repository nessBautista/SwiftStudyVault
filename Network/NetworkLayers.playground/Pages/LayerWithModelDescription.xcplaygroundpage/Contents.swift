import UIKit
// The client implementing this layer requires 2 params
// 1) The endpoint (is type safe)
// 2) The output model

protocol EndpointType {
    var baseURL: URL { get }
    var endpoint: String { get }
    var headers: [String:String] { get }
    var clientID: String {get}
    var urlRequest: URLRequest{ get }
}
enum UnsplashEndPoint: EndpointType {
    case getPhotos(page: Int, perPage: Int, orderBy: String?)
    
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    var endpoint:String {
        return "/photos"
    }
    
    var headers: [String : String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        headers["Authorization"] = "Authorization: Client-ID \(self.clientID)"
        return headers
    }
    
    var clientID: String {
        return "TVaxbYcLeYTX5HSSlOASUAuZyQ_StH1sfsxehsWL_Oc"
    }
    var urlRequest: URLRequest {
        switch self {
        case .getPhotos(let page,let perPage,let orderBy):
            let url = baseURL.appendingPathComponent(self.endpoint)
            var params:[ String: Any] = [:]
            params["page"] = page
            params["per_page"] = perPage
            params["order_by"] = orderBy
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = [URLQueryItem]()
                for (key, value) in params {
                    let queryItem = URLQueryItem(name: key,
                                                 value: "\(value)"
                                                    .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                    urlComponents.queryItems?.append(queryItem)
                }
                if let urlWithEncodedParams = urlComponents.url {
                    var request = URLRequest(url: urlWithEncodedParams)
                    request.allHTTPHeaderFields = self.headers
                    return request
                }
            }
            return URLRequest(url: url)
        }
    }
}
enum UnsplashError: Error {
    case networkError
    case decoderError
}
protocol NetworkLayer {
    associatedtype EndPoint: EndpointType
    func fetch<Model: Decodable>(endpoint: EndPoint,
                                 model: Model.Type,
                               completion: @escaping(Result<Model, Error>)->Void) -> URLSessionDataTask
}

class UnsplashClient: NetworkLayer {
    typealias EndPoint = UnsplashEndPoint
    func fetch<Model: Decodable>(endpoint: EndPoint,
                                 model: Model.Type,
                               completion: @escaping(Result<Model, Error>)->Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: endpoint.urlRequest){  data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data else {
                completion(.failure(UnsplashError.networkError))
              return
            }
            if let photos = try? JSONDecoder().decode(Model.self, from: data) {
                if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                     in: .userDomainMask).first {
                    print("-----------\(documentDirectory)")
                    let pathWithFileName = documentDirectory.appendingPathComponent("myJsonData")
                    do {
                        try data.write(to: pathWithFileName)
                    } catch {
                        // handle error
                        print(error)
                    }
                    print("-----------")
                }
                completion(.success(photos))
            } else {
                completion(.failure(UnsplashError.decoderError))
            }
        }
        task.resume()
        return task
    }
}

let unsplashClient = UnsplashClient()
unsplashClient.fetch(endpoint: .getPhotos(page: 1, perPage: 10, orderBy: nil),
                     model: [Photo].self) { result in
    //print(result)
}

print("ok")

