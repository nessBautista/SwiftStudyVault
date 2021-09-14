//: [Previous](@previous)

import Foundation

var result: Int?
// MARK: Simple Operation Block
let sumOperation = BlockOperation {
    result = 2 + 3
    sleep(2)
}

duration {
    //Remember Block Operations runs synchronously
    sumOperation.start()
}
result

// MARK: Working with multiple block operations
let multiPrinter = BlockOperation()
multiPrinter.addExecutionBlock { print("Hello"); sleep(2)}
multiPrinter.addExecutionBlock { print("My"); sleep(2)}
multiPrinter.addExecutionBlock { print("Name"); sleep(2)}
multiPrinter.addExecutionBlock { print("is"); sleep(2)}
multiPrinter.addExecutionBlock { print("Ness"); sleep(2)}

duration {
    multiPrinter.start()
}
// Blocks must be independent, because these run on the global queue by default. You cannot use the result from one block in another block, because you have no control over the order they run in.
//: [Next](@next)
