//
//  Workflows.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 21/06/21.
//
//maybe using: https://developer.apple.com/documentation/dispatch/1453125-dispatch_get_specific
//To add specific data

import Foundation
enum WorkflowError: Error {
    case APIError
    case serializationError
    case DatabaseError
}

protocol HandableRequest {
    func getKeyValueRequest()->[String: Any]?
}

enum RequestHandlerType {
    case sessionValidation
    case coordinatorNotifier(screen: AppScreen)
}

protocol Handler: AnyObject {
    var next: Handler? { get set }
    func setNext(_ next: Handler)
    func handle<Request>(_ request: Request?)
}
extension Handler {
    func setNext(_ next: Handler) {
        self.next = next
    }
}

protocol SessionValidation: Handler {
    var userSession: UserSessionable {get set}
    
}


class SessionValidator: SessionValidation {
    var next: Handler?
    var userSession: UserSessionable
    
    init(session: UserSessionable = UserSession()){
        self.userSession = session
    }
    
    func handle<Request>(_ request: Request? = nil) {
        if userSession.isLoggedIn {
            
        } else {
            
        }
    }
}

protocol CoordinatorNotifier: Handler {
    var coordinator: Coordinator {get set}
}

class CoordinatorNotification: CoordinatorNotifier {
    var next: Handler?
    var coordinator: Coordinator 

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    func handle<Request>(_ request: Request? = nil) {
        
    }
    
}

