//: [Previous](@previous)

import Foundation
// Here is an interesting exercise->

/*
    You are going to perform slowAdds using the asynchronous function.
    What is going to happen is that if you use the MainQueue as the completion queue, playground is going to fail.
 
    If you use a background queue as a completion queue, what is going to happen is that the DispatchGroup will be notified as long as the task have been dispatched. Even thought the operations are still being executed, which means that: ** The dispatchGroup considers task have finished once are out of the executing thread, even if this happens because tasks are dispatched asyncrhonously **
 */


enum SlowAddError: Error {
    case notEnoughtFingers
}
let userQueue = DispatchQueue.global(qos: .userInitiated)
let mainQueue = DispatchQueue.main
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

func slowAddAsync(_ input: (Int, Int),
             runQueue: DispatchQueue = userQueue,
             completionQueue: DispatchQueue =  userQueue,
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

let slowAddGroup = DispatchGroup()

for value in numberArray {
    userQueue.async(group: slowAddGroup) {
        slowAddAsync(value) { result in
            print("Result: \(result)")
        }
    }
}

slowAddGroup.notify(queue: mainQueue) {
    print("SLOWADD---> Task finished")
}
//: [Next](@next)
