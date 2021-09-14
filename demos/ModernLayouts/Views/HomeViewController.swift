//
//  HomeViewController.swift
//  ModernLayouts
//
//  Created by Nestor Hernandez on 13/06/21.
//

import Combine
import UIKit

class HomeViewController: UITableViewController{
    var viewModel: HomeViewModel = HomeViewModel()
    private var subscriptions =  Set<AnyCancellable>()
    private var items:[HomeItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        self.bindToViewModel()
        self.loadItems()
    }
    
    private func loadItems() {
        self.viewModel.loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.display(indexPath.row)
    }
    
    private func display(_ idx: Int) {
        switch idx {
        case 0:
            let vc = BasicListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

// ViewModel Bindings
extension HomeViewController {
    func bindToViewModel(){
        viewModel.homeItems.sink { items in
            self.items = items
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }
}
