import Foundation
// 1
class MockURLSession: URLSession {
    override func dataTask(
        with url: URL,
        completionHandler:
            @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        return MockURLSessionDataTask(
            completionHandler: completionHandler,
            url: url)
    }
    
}

// 2
class MockURLSessionDataTask: URLSessionDataTask {
    
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var url: URL
    var calledResume = false
    init(completionHandler:
            @escaping (Data?, URLResponse?, Error?) -> Void,
         url: URL) {
        self.completionHandler = completionHandler
        self.url = url
        super.init()
    }
    
    // 3
    override func resume() {
        // don't do anything
        self.calledResume = true
    }
}
