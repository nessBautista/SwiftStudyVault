//: [Previous](@previous)

import Foundation

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInteractive)
let sempahore = DispatchSemaphore(value: 4)

for i in 1...10 {
    queue.async(group: group) {
        sempahore.wait()
        defer { sempahore.signal() }
        print("Downloading image \(i)")
        Thread.sleep(forTimeInterval: 3)
        print("Image \(i) downloaded")
        
    }
}
//: [Next](@next)
