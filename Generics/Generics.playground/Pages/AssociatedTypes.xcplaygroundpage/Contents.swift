//: [Previous](@previous)

import Foundation
// Generic Stack with an associated type (associatedtypes are the generics of protocols)
protocol Stack {
    associatedtype Element
    var count: Int { get }
    mutating func push(_ item: Element)
    mutating func pop()-> Element?
}

// Implementing a Protocol with an associated type
struct MyStackOfInts: Stack {
    var stack:[Int] = []
    var count: Int {
        return stack.count
    }
    
    mutating func push(_ item: Int) {
        self.stack.append(item)
    }
    
    mutating func pop() -> Int? {
        return stack.popLast()
    }
    
}

// Generics + Associated Types
// Implementing a struct with Generics subscribed to a protocol with  an associated types
struct MyGenericStack<T>: Stack {
    private var stack:[T] = []
    
    var count: Int {
        return stack.count
    }
    
    mutating func push(_ item: T) {
        self.stack.append(item)
    }
    
    mutating func pop() -> T? {
        self.stack.popLast()
    }
}

// Using a protocol with associatedtype as a type in a function
func someMethod<Container: Stack>(container: Container) {
    print("Using a protocol with associatedtype as a type in a function")
}

let myGenericStackOfStrings = MyGenericStack<String>()
someMethod(container: myGenericStackOfStrings)
//: [Next](@next)
