//
//  AppHandler.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 21/06/21.
//

import Foundation

enum HandlerOutputType {
    case result(Result<Any, Error>)
    case coordinatorAction(AppScreen)
    case request(HandlerRequest)
    case networkRequest
}

typealias HandlerRequest = [String:Any]
protocol AppHandler {
    var process: AppProcessProtocol {get set} //The process it belongs to
    var next: AppHandler? {get set} // Next handler in the chain
    var output: HandlerOutputType? {get set} //the output of the process
    func setNext(handler: AppHandler)
    func handle(request: HandlerOutputType?)
}


protocol AppProcessProtocol: AnyObject {
    var register:[String: AppHandler] {get set}
    var currentHandler: AppHandler? {get set}
    var workerQueue: DispatchQueue {get set}
    var delegate: ProcessLifeCycle? {get set}
    var name: String {get set}
    func buildProcess()
    func execute()
}

enum ProcessError: Error {
    case APIError
    case serializationError
    case DatabaseError
}

protocol ProcessLifeCycle {
    func handlerDidStart()
    func didAddLog(message: String)
    func handlerDidFinish(finishedWithError: ProcessError?)
}

class SetupSessionProcess: AppProcessProtocol {
    var register: [String : AppHandler] = [:]
    
    var currentHandler: AppHandler? = nil
    
    var workerQueue: DispatchQueue
    
    var delegate: ProcessLifeCycle?
    
    var name: String
    
    var firstHandler: AppHandler?
    init(name: String,
         workerQueue: DispatchQueue = DispatchQueue(label: "SetupSessionProcess")) {
        self.name = name
        self.workerQueue = workerQueue
    }
    
    func buildProcess() {
        //1. Check if user has an active session
        let sessionValidator = SessionValidationHandler(process: self)
        //2. Send user to appropiated screen (home or login)
        let navigationHandler = NavigationHandler(process: self)
        
        sessionValidator.setNext(handler: navigationHandler)
        firstHandler = sessionValidator
    }
    
    func execute() {
        workerQueue.async {
            self.delegate?.handlerDidStart()
            self.firstHandler?.handle(request: nil)
        }
        
    }
}
//extension SetupSessionProcess: ProcessLifeCycle {
//    func handlerDidStart() {
//        print("\(self.name) process Started")
//    }
//
//    func didAddLog(message: String) {
//        print(message)
//    }
//
//    func handlerDidFinish(finishedWithError: ProcessError?) {
//        guard let error = finishedWithError else {
//            print("\(self.name) process finished successfully")
//            return
//        }
//        print("\(self.name) process finished with error: \(error)")
//    }
//}
class SessionValidationHandler: AppHandler {
    
    unowned var process: AppProcessProtocol
    var next: AppHandler?
    var output: HandlerOutputType?
    
    init(process: AppProcessProtocol) {
        self.process = process
    }
    
    func setNext(handler: AppHandler) {
        self.next = handler
    }
    
    func handle(request: HandlerOutputType?) {
        self.process.delegate?.didAddLog(message: "-SessionValidationHandler: Checking User session status")
        let user = UserSession()
        
        if user.isLoggedIn {
            self.output = .coordinatorAction(.home)
            self.process.delegate?.didAddLog(message: "-SessionValidationHandler: Used logged in")
        } else {
            self.output = .coordinatorAction(.login)
            self.process.delegate?.didAddLog(message: "-SessionValidationHandler: User Not Logged")
        }
        self.process.delegate?.didAddLog(message: "-SessionValidationHandler: completed")
        self.next?.handle(request: output)
    }

}

class NavigationHandler: AppHandler {
    unowned var process: AppProcessProtocol
    
    var next: AppHandler?
    
    var output: HandlerOutputType?
    
    init(process: AppProcessProtocol) {
        self.process = process
    }
    func setNext(handler: AppHandler) {
        self.next = handler
    }
    
    func handle(request: HandlerOutputType?) {
        self.process.delegate?.didAddLog(message: "-NavigationHandler: Started")
        switch request {
        case .coordinatorAction(let navScreen):
            NotificationCenter.default.post(name: NSNotification.Name.init(Constants.Coordinator.Navigation.rawValue),
                                            object: navScreen)
            self.process.delegate?.didAddLog(message: "-NavigationHandler: Dispatched to Coordinator")
            self.process.delegate?.didAddLog(message: "-NavigationHandler: Completed")
            self.process.delegate?.handlerDidFinish(finishedWithError: nil)
        default:
            break
        }
        
    }
}
