//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

class User: NSObject {
    @objc dynamic var name = "Nestor"
    @objc var age = 0 {
        willSet{ willChangeValue(forKey: #keyPath(age))}
        didSet{ didChangeValue(for: \User.age)}
    }
}

class ViewController: UIViewController {
    @objc let user = User()
    var ageLabel: UILabel?
    var nameLabel: UILabel?
    var nameObserver: NSKeyValueObservation?
    var ageObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        self.setupUI()
        nameObserver = observe(\.user.name, options: [.new]) { vc, change in
            print(change)
            vc.nameLabel?.text = "User Name:\(change.newValue ?? String())"
        }
        
        ageObserver = observe(\.user.age, options: [.new], changeHandler: { vc, change in
            print(change)
            
            vc.ageLabel?.text = "User Age:\(change.newValue ?? 0)"
        })
    }
    
    func setupUI(){
        var views: [UIView] = []
        let ageLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                          width: 300, height: 50))
        ageLabel.text = "User Age:\(user.age)"
        self.ageLabel = ageLabel
        views.append(ageLabel)
        let ageButton = UIButton(frame: CGRect(x: 0, y: 50,
                                               width: 300, height: 50))
        ageButton.setTitle("Age Button", for: .normal)
        ageButton.backgroundColor = .orange
        ageButton.addTarget(self, action: #selector(updateAge), for: .touchUpInside)
        views.append(ageButton)
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 150,
                                          width: 300, height: 50))
        nameLabel.text = "User Name:\(user.name)"
        self.nameLabel = nameLabel
        views.append(nameLabel)
        
        let nameButton = UIButton(frame: CGRect(x: 0, y: 200,
                                               width: 300, height: 50))
        nameButton.setTitle("Name Button", for: .normal)
        nameButton.backgroundColor = .orange
        nameButton.addTarget(self, action: #selector(updateName), for: .touchUpInside)
        views.append(nameButton)
        
        
        views.forEach({self.view.addSubview($0)})
        
    }
    
    @objc func updateAge() {
        self.user.age = 35
        print("updated Age")
    }
    
    @objc func updateName() {
        
        self.user.name = "Ness"
        print("updatedName")
    }
    
}




let vc = ViewController()
vc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
print("ok")
//: [Next](@next)
