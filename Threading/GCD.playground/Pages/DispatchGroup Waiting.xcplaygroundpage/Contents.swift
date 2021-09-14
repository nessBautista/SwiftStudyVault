//: [Previous](@previous)

import Foundation

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)


queue.async(group: group) {
    print("Start task 1")
    sleep(4)
    print("End task 1")
}

queue.async(group: group) {
    print("Start task 2")
    sleep(1)
    print("End task 2")
}

group.notify(queue: DispatchQueue.global()) {
    print("All tasks completed at last!")
}

//Current thread is going to wait for the group to finish (not ideally in th emsin thread)
if group.wait(timeout: .now() + 5) == .timedOut {
    print("I got tired of waiting")
} else {
    print("All the task have been completed")
}

//: [Next](@next)
