import Foundation
public enum State: String {
    case ready, executing, finished
    
    var keyPath: String {
        "is\(rawValue.capitalized)"
    }
}
open class AsyncOperation: Operation {
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    // Override properties
    override open var isReady: Bool {
      super.isReady && state == .ready
    }

    override open var isExecuting: Bool {
        state == .executing
    }
    
    override open var isFinished: Bool {
        state == .finished
    }
    
    //Only needed if operation will run outside the OperationQueue
    //It ensures the operation runs off the main thread
    public override var isAsynchronous: Bool {
        true
    }
    
    public override func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
    }
    
    open override func cancel() {
        state = .finished
    }
}
