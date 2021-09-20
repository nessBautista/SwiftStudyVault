//: [Previous](@previous)

import Foundation

//Model
struct Model: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

let strUrl = "https://jsonplaceholder.typicode.com/todos"
let url = URL(string: strUrl)!
let request = URLRequest(url: url)
var todoList:[Model] = []

let task = URLSession.shared.dataTask(with: request){   data, response, error in
    guard error == nil else {
        return
    }
    guard let data = data else { return }
    if let models = try? JSONDecoder().decode([Model].self, from: data) {
        print(models)
    }
    
}
task.resume()


//: [Next](@next)
