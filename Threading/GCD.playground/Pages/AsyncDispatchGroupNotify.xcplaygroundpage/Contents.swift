//: [Previous](@previous)

import Foundation

let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

enum SlowAddError: Error {
    case notEnoughtFingers
}

// Normal Function
func slowAdd(_ input: (Int, Int)) -> Result<Int, SlowAddError> {
    if Bool.random() {
        sleep(1)
        return .success(input.0 + input.1)
    }
    else {
        return .failure(SlowAddError.notEnoughtFingers)
    }
}

// Async function wrapper
func asyncAdd(_ input: (Int, Int),
              runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
              completionQueue: DispatchQueue = DispatchQueue.main,
              completion: @escaping(Result<Int, SlowAddError>) -> ()) {
    runQueue.async {
        let result = slowAdd(input)
        completionQueue.async {
            completion(result)
        }
    }
}

// Async Group that will notify
func asyncAdd_Group(_ input: (Int, Int),
                     runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
                     completionQueue:DispatchQueue = DispatchQueue.main,
                     group: DispatchGroup,
                     completion: @escaping (Result<Int, SlowAddError>)-> ()) {
    group.enter()
    asyncAdd(input) { result in
        defer {group.leave()}
        completionQueue.async {
            completion(result)
        }
    }
}

let wrappedGroup = DispatchGroup()
for pair in numberArray {
    asyncAdd_Group(pair,
                   group: wrappedGroup) { result in
        print("AsyncOp finished. Result = \(result)")
    }
}

wrappedGroup.notify(queue: DispatchQueue.main) {
    print("Wrapper async add: Completed all tasks")
}


/* Why this is important
 
 Because if you would apply the notify on an Async group execution, without using the "Enter" and "Leave" functions, the task would return inmediately.
 */
//: [Next](@next)
