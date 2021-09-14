//: [Previous](@previous)

import UIKit
import Foundation
import PlaygroundSupport

class ViewController: UITableViewController {

    private var urls: [URL] = []
        
    
    let globalQueue = DispatchQueue.global(qos: .utility)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urls = getURLs()
        self.tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
    }
    
    func getURLs() -> [URL] {
        guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              let serialUrls = serial as? [String] else {
                
            print("Something went horribly wrong!")
            return []
        }
        let urls = serialUrls.compactMap { URL(string: $0) }
        
        return urls
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoCell
        cell?.backgroundColor = .blue
        cell?.load(image: nil)
        downloadWithURLSession(at: indexPath)
        return cell ?? UITableViewCell()
    }
    
    private func downloadWithURLSession(at indexPath: IndexPath) {
        
        URLSession.shared.dataTask(with: self.urls[indexPath.row]) {
            (data, response, error) in
            guard let rawData = data else { return }
            if let image = UIImage(data: rawData) {
                // back to main thread
                DispatchQueue.main.async {
                    let cell = self.tableView.cellForRow(at: indexPath) as? PhotoCell
                    
                    cell?.load(image: image)
                }
            }
            
        }.resume()
        
    }
}




let vc = ViewController()
vc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true


//: [Next](@next)
