//: [Previous](@previous)

import Foundation
import PlaygroundSupport
// a low priority queue will lock a resource needed by a high priority queue
let high = DispatchQueue.global(qos: .userInteractive)
let medium = DispatchQueue.global(qos: .userInitiated)
let low = DispatchQueue.global(qos: .background)

// This sempahore controll the access to the resources
let semaphore = DispatchSemaphore(value: 1)

// Dispatch task that sleeps before calling sempahore.wait()
high.async {
    sleep(2)
    print("High priority task is now waiting")
    semaphore.wait()
    defer {semaphore.signal()}
    print("High priority task is now running")
    PlaygroundPage.current.finishExecution()
}

for i in 1...10 {
    medium.async {
        print("Running medium task \(i)")
        let waitTime = Double(Int.random(in: 0..<7))
        Thread.sleep(forTimeInterval: waitTime)
    }
}

low.async {
    semaphore.wait()
    defer { semaphore.signal() }
    print("Low priority task is now running")
    sleep(5)
    
}
//: [Next](@next)
