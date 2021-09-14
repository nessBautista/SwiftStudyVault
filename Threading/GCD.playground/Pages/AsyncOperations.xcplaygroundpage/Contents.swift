//: [Previous](@previous)

import Foundation
import PlaygroundSupport

extension AsyncOperation {
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }
}
class AsyncOperation: Operation {
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isExecuting: Bool {
        state == .executing
    }
    
    override var isFinished: Bool {
        state == .finished
    }
    
    //Only needed if operation will run outside the OperationQueue
    //It ensures the operation runs off the main thread
    override var isAsynchronous: Bool {
        true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
    }
    
    override func cancel() {
        state = .finished
    }
}

class AsyncSumOperation: AsyncOperation {
    let rhs: Int
    let lhs: Int
    
    var result: Int?
    
    init(lhs: Int, rhs: Int) {
        self.lhs = lhs
        self.rhs = rhs
        super.init()
    }
    
    override func main() {
        DispatchQueue.global().async {
            sleep(2)
            self.result = self.lhs + self.rhs
            //End Operation
            self.state = .finished
        }
    }
}

let queue = OperationQueue()
print("Underlaying Queue: \(queue.underlyingQueue)")
let pairs = [(2,3),(5,3),(1,7),(12,34),(99,99)]
pairs.forEach { pair in
    let op = AsyncSumOperation(lhs: pair.0, rhs: pair.1)
    op.completionBlock = {
        guard let result = op.result else { return }
        print("\(pair.0) + \(pair.1) = \(result)")
    }
    queue.addOperation(op)
}

queue.waitUntilAllOperationsAreFinished()
PlaygroundPage.current.finishExecution()
//: [Next](@next)
