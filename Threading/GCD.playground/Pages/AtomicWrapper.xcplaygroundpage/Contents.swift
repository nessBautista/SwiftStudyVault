//: [Previous](@previous)

import Foundation
public class AtomicSet<Hashable:Swift.Hashable> {
    var atomicSet = Set<Hashable>()
    
    private let queue = DispatchQueue(label: "com.donnywals.\(UUID().uuidString)",
                                      qos: .utility,
                                      attributes: .concurrent)
    
    public init() {}
    
    public func insert(value: Hashable) {
        queue.async(flags:.barrier) {
            self.atomicSet.insert(value)
        }
    }
    
    public func contains(value: Hashable) -> Bool {
        queue.sync {
            self.atomicSet.contains(value)
        }
    }
}

var atomicSet = AtomicSet<Int>()
let g = DispatchGroup()

for index in (0..<10) {
    g.enter()
    DispatchQueue.global().async {
        atomicSet.insert(value: index)
        g.leave()
    }
}

g.notify(queue: .main, execute: {
    print(atomicSet.atomicSet)
})
//: [Next](@next)
