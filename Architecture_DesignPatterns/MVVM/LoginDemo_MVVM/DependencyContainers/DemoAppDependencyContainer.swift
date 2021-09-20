//
//  DemoAppDependencyContainer.swift
//  LoginDemo_MVVM
//
//  Created by Nestor Hernandez on 15/09/21.
//

import Foundation

public class DemoAppDependencyContainer {
    
    // MARK: - Properties
    //long-lived dependencies
    
    let sharedMainViewModel: MainViewModel
    let sharedUserSessionRepository: UserSessionRepository
    
    public init() {
        
        func makeMainViewModel()-> MainViewModel {
            return MainViewModel()
        }
        
        func makeUserSessionRepository() -> UserSessionRepository {
            let authAPI = makeAuthRemoteAPI()
            let dataStore = makeUserSessionDataStore()
            return AppUserSessionRepository(authRemoteApi: authAPI,
                                            userSessionDataStore: dataStore)
        }
        
        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return FakeAuthRemoteAPI()
        }
        
        func makeUserSessionDataStore() -> UserSessionDataStore {
            return FileUserSessionDataStore()
        }
        
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedUserSessionRepository = makeUserSessionRepository()
    }
    
    public func makeMainViewController() -> MainViewController {
        let signedInViewControllerFactory = {
            return self.makeSignedInViewController()
        }
        
        let onboardingViewController = {
            return self.makeOnboardingViewController()
        }
        
        let mainVC = MainViewController(viewModel: self.sharedMainViewModel,
                                        onboardingViewController: onboardingViewController,
                                        signedInViewController: signedInViewControllerFactory)
        
        return mainVC
    }
    
    public func makeSignedInViewController() -> SignedInViewController {
        return SignedInViewController()
    }
    
    public func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController()
    }
}
