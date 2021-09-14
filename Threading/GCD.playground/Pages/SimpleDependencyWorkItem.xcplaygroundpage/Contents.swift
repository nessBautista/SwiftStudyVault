//: [Previous](@previous)

import Foundation

//The main Queue
let mainQueue = DispatchQueue.main
//A Serial private queue
let userQueue = DispatchQueue.global(qos: .userInitiated)

enum Queues {case mainQ, userQ}
let specifyKey = DispatchSpecificKey<Queues>()
mainQueue.setSpecific(key: specifyKey, value: .mainQ)
userQueue.setSpecific(key: specifyKey, value: .userQ)
func whichQueue(workItem: String) {
    switch DispatchQueue.getSpecific(key: specifyKey) {
    case .mainQ:
        print(">>>\(workItem) is running on mainQueue")
    case .userQ:
        print(">>>\(workItem) is running on userQueue")
    default:
        break
    }
}


func backgroundTask(){
    print("backgroundTask started")
    sleep(4)
    print("backgroundTask finished")
}

func updateUITask(){
    print("updateUITask started")
    print("updateUITask finished")
}



// With work items you can declare simple dependencies
let backgroundWorkItem = DispatchWorkItem {
    backgroundTask()
    whichQueue(workItem: "backgroundWorkItem")
}
let updateUIWorkItem = DispatchWorkItem {
    updateUITask()
    whichQueue(workItem: "updateUIWorkItem")
}

userQueue.async(execute: backgroundWorkItem)
backgroundWorkItem.notify(queue: mainQueue, execute: updateUIWorkItem)


// You can also cancel the work item
print(">> Cancel updateUITask workItem before Backgroundtask workItem finishes")
if !updateUIWorkItem.isCancelled {
    updateUIWorkItem.cancel()
    
}
//: [Next](@next)
