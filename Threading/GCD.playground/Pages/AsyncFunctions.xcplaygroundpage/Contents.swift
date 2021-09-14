//: [Previous](@previous)

import Foundation
import Combine

//Execution Domain Errors
enum SlowAddError: Error {
    case notEnoughtFingers
}

// Domains of execution
let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
let privateSerialQueue = DispatchQueue.init(label: "serialQueueForWriting")
let mainQueue = DispatchQueue.main

func slowAdd(_ input: (Int, Int),
             runQueue: DispatchQueue = userInitiatedQueue,
             completionQueue: DispatchQueue =  mainQueue,
             completion: @escaping(Result<Int, SlowAddError>) ->()) {
    
    runQueue.async {
        if Bool.random() {
            completionQueue.async {
                sleep(2)
                completion(.success(input.0 + input.1))
            }
        }
        else {
            completionQueue.async {
                completion(.failure(SlowAddError.notEnoughtFingers))
            }
        }
    }
}
let input = [(1,2)]
let output = PassthroughSubject<Int, SlowAddError>()

let subscription: AnyCancellable = input.publisher
    .receive(on: DispatchQueue.global(qos: .userInitiated))
    .sink { input in
    print("About to execute slowAdd in thread: \(Thread.current)")
    slowAdd(input) { result in
        print("SlowAdd finished on thread: \(Thread.current)")
        switch result {
        case .success(let result):
            output.send(result)
        case .failure(let error):
            output.send(completion: .failure(error))
        }
    }
}

let subscription2: AnyCancellable =  output
                .receive(on: DispatchQueue.global(qos: .userInitiated))
                .sink { completion in
                    print("Received final error on thread: \(Thread.current)")
                    } receiveValue: { result in
                        print("Received Final Result \(result) on thread: \(Thread.current)")
                            print(result)
                    }


//slowAdd((1,2)) { result in
//    switch result {
//    case .success(let output):
//        print("the addition operation is: \(output)")
//    case .failure(let error):
//        print("Got error \(error)")
//
//    }
//}

//: [Next](@next)
