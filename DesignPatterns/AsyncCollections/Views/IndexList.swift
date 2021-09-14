//
//  IndexList.swift
//  AsyncCollections
//
//  Created by Nestor Hernandez on 02/06/21.
//

import UIKit

class IndexList: UITableViewController {
    let vm = IndexViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.index.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = vm.index[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = AsyncList01()
            self.push(vc)
            
        default:
            break
        }
    }
    
    fileprivate func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
