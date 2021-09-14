//: [Previous](@previous)

import Foundation


func mockTask(id: String) {
    print("\(id) mock task started in thread:\(Thread.current)")
    sleep(2)
    print("mock task finished")
}

// NOTE: The private queues, are by default serial
let serialQueue = DispatchQueue(label: "com.nesslab.serialQueue", qos: .background)
// NOTE: If you need to create a concurrentQueue, you need to specify .concurrent as attribute:
let concurrentQueue = DispatchQueue(label: "com.nesslab.concurrentQueue", qos: .background, attributes: .concurrent)


func test_sync_to_concurrentQueue(){
    print("---Dispatching Synchronously from the main thread into a Concurrent Queue--- ")
    print("------Main thread -> \(Thread.isMainThread)")
    print("*** Interesting fact is that when dispatching SYNCHRONOUSLY, will execute the task in the same thread (not our intent when creating private queues). Mind the difference between QUEUES and THREADS. Everything will be executed on the main thread")
    concurrentQueue.sync {
        print("------Main thread -> \(Thread.isMainThread)")
        mockTask(id: "pepito")
    }
    concurrentQueue.sync {
        print("------Main thread -> \(Thread.isMainThread)")
        mockTask(id: "luisito")
    }
    print("--- Continue with main thread")
}
test_sync_to_concurrentQueue()
//: [Next](@next)
