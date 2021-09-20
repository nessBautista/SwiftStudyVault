//
//  AppUserSessionRepository.swift
//  LoginDemo_MVVM
//
//  Created by Nestor Hernandez on 15/09/21.
//

import Foundation

public class AppUserSessionRepository: UserSessionRepository {
    let authRemoteApi: AuthRemoteAPI
    let userSessionDataStore: UserSessionDataStore
    
    init(authRemoteApi: AuthRemoteAPI,
         userSessionDataStore: UserSessionDataStore) {
        self.authRemoteApi = authRemoteApi
        self.userSessionDataStore = userSessionDataStore
    }
}
