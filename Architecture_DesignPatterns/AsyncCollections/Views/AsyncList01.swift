//
//  AsyncList01.swift
//  AsyncCollections
//
//  Created by Nestor Hernandez on 02/06/21.
//

import UIKit

class AsyncList01: UITableViewController {
    var viewModel: ViewModel01 = ViewModel01()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(Cell01.self, forCellReuseIdentifier: "Cell01")
        
        self.bindUI()
    }
    
    private func bindUI(){
        self.viewModel.onModelsDidLoad = { [weak self] (models, idx) in
            self?.tableView.reloadRows(at: [idx], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell01") as? Cell01
        if let imageData = self.viewModel.models[indexPath.row].rawImage {
            cell?.imageview.image = UIImage(data: imageData)
        } else {
            self.viewModel.fetchImage(idx: indexPath)
        }
        
        
        
        return cell ?? UITableViewCell()
    }
    
}
