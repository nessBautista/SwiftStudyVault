//
//  HomeViewController.swift
//  PhotoApp_Classic
//
//  Created by Nestor Hernandez on 18/06/21.
//

import UIKit
class HomeViewController: UITableViewController {
    @objc let viewModel = HomeViewModel()
    var itemsObserver: NSKeyValueObservation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIConfig()
        self.setupBindings()
        self.viewModel.loadHomeItems()
//        let e1 = UnsplashEndPoint<[Photo]>.photos(page: 1,
//                                                 perPage: 10,
//                                                 orderBy: nil)
//        let e2 = UnsplashEndPoint<[Photo]>.photos(page: 1,
//                                                 perPage: 10,
//                                                 orderBy: nil)
//        print(e1 == e2)
//        viewModel.networkClient.fetch(endpoint: e1) { result in
//            print("----received: \n\(result)")
//        }
//        viewModel.networkClient.fetch(endpoint: e2) { result in
//            print("----received: \n\(result)")
//        }
    }
    
    func UIConfig() {
        self.tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    
    func setupBindings() {
        itemsObserver = observe(\.viewModel.items,
                                options: [.new],
                                changeHandler: { vc, change in
                                    
                                    print("current page: \(vc.viewModel.pageNumber), itemsInPage: \(vc.viewModel.items.count)")
                                    vc.reloadItems()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let homeItem = viewModel.item(at: indexPath) {
            cell.textLabel?.text = "\(homeItem.user.username)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.items.count - 1 else { return }
        viewModel.loadHomeItems()
    }
    
    func reloadItems(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
