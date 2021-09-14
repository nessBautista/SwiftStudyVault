//: [Previous](@previous)

import Foundation
import PlaygroundSupport
var greeting = "Hello, playground"
let person = Person(firstName: "Adrea", lastName: "Anderson")
let nameList = [("Charlie", "Cheesecake"), ("Delia", "Dingle"),
                ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

let workerQueue = DispatchQueue(label: "com.gcd.lab", attributes: .concurrent)
let nameChangeGroup = DispatchGroup()
for (idx, name) in nameList.enumerated() {
    workerQueue.async(group: nameChangeGroup) {
        usleep(UInt32(10_000 * idx))
        person.changeName(firstName: name.0, lastName: name.1)
        print("Name Chaged to:\(person.name)")
    }
}

nameChangeGroup.notify(queue: DispatchQueue.global()) {
    print("Final name: \(person.name)")
    PlaygroundPage.current.finishExecution()
}
 class Person {
    private var firstName: String
    private var lastName: String
    
    public init(firstName: String, lastName: String) {
      self.firstName = firstName
      self.lastName = lastName
    }
    
    open func changeName(firstName: String, lastName: String) {
        randomDelay(maxDuration: 0.2)
        self.firstName = firstName
        randomDelay(maxDuration: 1)
        self.lastName = lastName
    }
    
    open var name: String {
      "\(firstName) \(lastName)"
    }
    
    // This random delay simulates being part of a bigger app
    func randomDelay(maxDuration: Double) {
      //  let randomWait = arc4random_uniform(UInt32(maxDuration * Double(USEC_PER_SEC)))
      let randomWait = UInt32.random(in: 0..<UInt32(maxDuration * Double(USEC_PER_SEC)))
      usleep(randomWait)
    }
}

//: [Next](@next)
