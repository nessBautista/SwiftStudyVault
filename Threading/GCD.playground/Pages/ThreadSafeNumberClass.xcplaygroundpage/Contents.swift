//: [Previous](@previous)

import Foundation


class Number {
    var value: Int
    var name: String
    private let isolationQueue = DispatchQueue(label: "isolationQueue", attributes: .concurrent)
    init(value: Int, name: String) {
        self.value = value
        self.name = name
    }
    
    func changeNumber(_ value: Int, name: String) {
        print("WorkerQueue--\(Thread.current)")
        isolationQueue.async(flags: .barrier) {
            print("|---Barrier IsolationQueue--\(Thread.current)")
            randomDelay(maxDuration: 0.1)
            self.value = value
            randomDelay(maxDuration: 0.5)
            self.name = name
        }        
    }
    
    var number: String {
        return isolationQueue.sync {
            print("|-- Sync IsolationQueue--\(Thread.current)")
            return "\(value) :: \(name)"
        }
    }
}

let changingNumber = Number(value: 0, name: "zero")
let numberArray = [(1, "one"), (2, "two"),
                   (3, "three"), (4, "four"),
                   (5, "five"), (6, "six")]
let workerQueue = DispatchQueue(label: "ConcurrentQueue.worker",
                                attributes: DispatchQueue.Attributes.concurrent)
let numberGroup = DispatchGroup()
func changeNumber() {
  for pair in numberArray {
    workerQueue.async(group: numberGroup) {
      changingNumber.changeNumber(pair.0, name: pair.1)
      print("Current number: \(changingNumber.number)")
    }
  }
  
  // When made thread-safe, prints Final number: 6 :: six
  numberGroup.notify(queue: DispatchQueue.main) {
    print("Final number: \(changingNumber.number) in Thread: (\(Thread.current)")
  }
}

changeNumber()
//: [Next](@next)
