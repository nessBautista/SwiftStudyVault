//
//  MainViewController.swift
//  LoginDemo_MVVM
//
//  Created by Nestor Hernandez on 15/09/21.
//

import UIKit

public class MainViewController: UIViewController {
    
    let mainViewModel: MainViewModel
    let makeSignedInViewController: ()-> SignedInViewController
    let makeOnboardingViewController: ()-> OnboardingViewController
    
    public init(viewModel: MainViewModel,
                onboardingViewController: @escaping ()-> OnboardingViewController,
                signedInViewController: @escaping()-> SignedInViewController) {
        self.mainViewModel = viewModel
        self.makeSignedInViewController = signedInViewController
        self.makeOnboardingViewController = onboardingViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError("No Nib files for now, we will user dependency injection")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .orange
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
