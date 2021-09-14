//: [Previous](@previous)

import Foundation
// Dispatch Groups are like coloring tasks
let userQueue = DispatchQueue.global(qos: .userInitiated)
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]
func slowAdd(_ input: (Int, Int)) -> Int {
  sleep(1)
  return input.0 + input.1
}

//create a dispatchGroup
let slowAddGroup = DispatchGroup()

for inValue in numberArray {
    userQueue.async(group: slowAddGroup) {
        let result = slowAdd(inValue)
        print("Result = \(result)")
    }
}

//Notification of a group completion
let mainQueue = DispatchQueue.main
slowAddGroup.notify(queue: mainQueue) {
    print("SLOWADDS: completed all tasks")
}


//: [Next](@next)
