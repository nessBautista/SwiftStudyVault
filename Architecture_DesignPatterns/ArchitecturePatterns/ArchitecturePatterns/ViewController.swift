//
//  ViewController.swift
//  ArchitecturePatterns
//
//  Created by Nestor Hernandez on 28/05/21.
//

import UIKit
import Combine
class ViewController: UIViewController {

    //MARK: UI Outlets
    @IBOutlet weak var mvcTextField: UITextField!
    @IBOutlet weak var mvpTextField: UITextField!
    @IBOutlet weak var mvvmmTextField: UITextField!
    @IBOutlet weak var mvvmTextField: UITextField!
    @IBOutlet weak var elmTextField: UITextField!
    @IBOutlet weak var mvcvsTextField: UITextField!
    @IBOutlet weak var mavbTextField: UITextField!
    @IBOutlet weak var cleanTextField: UITextField!
    
    //MARK: properties
    var mvcObserver: NSObjectProtocol?
    var presenter: ViewPresenter?
    
    //MARK: Model
    var model = Model(value: String())
    
    // MVVM
    var viewModel: ViewModel?
    var mvvmObserver: Cancellable?
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mvcDidLoad()
        mvpDidLoad()
        mvvmDidLoad()
    }
    
    //MARK: Commit Button Actions
    @IBAction func mvcButton(_ sender: Any) {
        model.value = mvcTextField?.text ?? String()
    }
    
    
    
    
    @IBAction func mvvmmButton(_ sender: Any) {
    }
    
    @IBAction func mvcvsButton(_ sender: Any) {
    }
    
    @IBAction func elmButton(_ sender: Any) {
    }
    @IBAction func mavbAction(_ sender: Any) {
    }
    @IBAction func cleanButton(_ sender: Any) {
    }
    
}

// MVC
/*
 1. Set the initial value
 2. Then you observer
 3. combine with view state data on the return path (we pull the value from the textfield to the model)
 */
extension ViewController {
    func mvcDidLoad() {
        mvcTextField.text = model.value
        mvcObserver = NotificationCenter.default.addObserver(forName: Model.textDidChange,
                                               object: nil,
                                               queue: nil) { [mvcTextField] notification in
            guard let text = notification.userInfo?[Model.textKey] as? String else {
                return
            }
            mvcTextField?.text = text
        }
    }
}

// MVP
/* Avoids to having the logic of the controller be tide tot he implementation of the views.
 
 */
// This protocol is a presentation of the setable values of the view
protocol ViewProtocol: AnyObject {
    var textFieldValue: String { get set }
}

class ViewPresenter {
    var model: Model
    weak var view: ViewProtocol?
    let observer: NSObjectProtocol
    
    init(model: Model, view: ViewProtocol) {
        self.model = model
        self.view = view
    
        view.textFieldValue = model.value
        observer = NotificationCenter.default.addObserver(forName: Model.textDidChange,
                                               object: nil,
                                               queue: nil) { [view] notification in
            guard let text = notification.userInfo?[Model.textKey] as? String else {
                return
            }
            view.textFieldValue = text
        }
    }
    
    func commit() {
        self.model.value = view?.textFieldValue ?? String()
    }
}

extension ViewController: ViewProtocol {
    var textFieldValue: String {
        get {
            return self.mvpTextField.text ?? String()
        }
        set {
            self.mvpTextField.text = newValue
        }
    }
    
    func mvpDidLoad() {
        presenter = ViewPresenter(model: model, view: self)
    }
    @IBAction func mvpButton(_ sender: Any) {
        presenter?.commit()
    }
}

// MVVM
class ViewModel {
    var model: Model
    init(model: Model) {
        self.model = model
    }
    // A publisher
    var textFieldValue = NotificationCenter.default
        .publisher(for: Model.textDidChange)
        .compactMap { notification in
            notification.userInfo?[Model.textKey] as? String
        }
    
    func commit(value: String) {
        model.value = value
    }
}
extension ViewController {
    func mvvmDidLoad() {
        viewModel = ViewModel(model: model)
        mvvmObserver = viewModel?.textFieldValue
            .sink(receiveValue: { [weak self] value in
            self?.mvvmTextField.text = value
        })
    }
    @IBAction func mvvmButton(_ sender: Any) {
        self.viewModel?.commit(value: mvvmTextField.text ?? String())
    }
}
