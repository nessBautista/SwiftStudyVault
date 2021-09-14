//
//  UserSession.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 21/06/21.
//

import Foundation

protocol UserSessionable {
    var isLoggedIn: Bool {get set}
    var accessToken: String {get set}
}

class UserSession: UserSessionable, DefaultStorable {
    var isLoggedIn: Bool {
        get {
            let isLoggedIn: Bool = self.getValue(for: Constants.Session.isLoggedIn.rawValue) as? Bool ?? false
            return isLoggedIn
        }
        set {
            self.setValue(newValue, for: Constants.Session.isLoggedIn.rawValue)
        }
    }
    var accessToken: String {
        get {
            return self.accessToken
        }
        set {
            self.accessToken = newValue
            self.setValue(newValue, for: Constants.Session.isLoggedIn.rawValue)
        }
    }
}
extension UserSession: HandableRequest {
    func getKeyValueRequest() -> [String : Any]? {
        var request:[String: Any] = [:]
        request["isLoggedIn"] = isLoggedIn
        return request
    }
}


protocol DefaultStorable {
    func setValue<Value>(_ value: Value,for key: String)
    func getValue(for key: String) -> Any?
}
extension DefaultStorable {
    func setValue<Value>(_ value: Value,for key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: key)
    }
    func getValue(for key: String) -> Any? {
        let userDefaults = UserDefaults.standard
        return userDefaults.value(forKey: key)
    }
}
