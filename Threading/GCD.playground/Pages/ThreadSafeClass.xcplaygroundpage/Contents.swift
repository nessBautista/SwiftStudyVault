//: [Previous](@previous)

import Foundation
import PlaygroundSupport
let person = SafePerson(firstName: "Adrea", lastName: "Anderson")
let nameList = [("Charlie", "Cheesecake"), ("Delia", "Dingle"),
                ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

let workerQueue = DispatchQueue(label: "threadSafeQueue", attributes: .concurrent)
let semaphore = DispatchSemaphore(value: 1)
let group = DispatchGroup()

for (idx, name) in nameList.enumerated() {
    workerQueue.async(group: group) {
        //semaphore.wait()
        //defer { semaphore.signal() }
        //usleep(UInt32(10_000 * idx))
        person.changeName(firstName: name.0, lastName: name.1)
        print("Name Chaged to:\(person.name)")
    }
}

group.notify(queue: DispatchQueue.main){
    print("Final name: \(person.name)")
    PlaygroundPage.current.finishExecution()
}



class SafePerson {
    // firstname and lastnames are the resources we need to protect
    private var firstName: String
    private var lastName: String
    //---> Read Operation is made serially through the isolation queue
    var name: String {
        isolationQueue.sync {
            return "\(firstName) \(lastName)"
        }
    }
    //Isolation queue
    let isolationQueue = DispatchQueue(label: "isolationQueue", attributes: .concurrent)
    //IsolationGroup
    //let semaphore = DispatchSemaphore(value: 1)
    
    public init(firstName: String, lastName: String) {
      self.firstName = firstName
      self.lastName = lastName
    }
    
    func changeName(firstName: String, lastName: String) {
        self.isolationQueue.async(flags: .barrier){
//            self.semaphore.wait()
//            defer { self.semaphore.signal() }
            randomDelay(maxDuration: 0.1)
            self.firstName = firstName
            randomDelay(maxDuration: 0.5)
            self.lastName = lastName
           print("Class Message-> ChangeName: \(firstName)-\(lastName)")
        }
    }
    
 
    
    
    
}
//: [Next](@next)
