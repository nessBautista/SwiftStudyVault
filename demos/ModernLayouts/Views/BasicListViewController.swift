//
//  BasicListViewController.swift
//  ModernLayouts
//
//  Created by Nestor Hernandez on 13/06/21.
//

import UIKit

class BasicListViewController: UIViewController {
    enum Section {
        case main
    }
    
    //MARK: - Variables
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collection: UICollectionView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIConfig()
        self.dataSourceConfig()
    }
    
    private func UIConfig(){
        self.collection = UICollectionView(frame: view.bounds, collectionViewLayout: self.getSimpleLayout())
        collection?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collection)
    }
    
    private func getSimpleLayout()-> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems:[item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func dataSourceConfig() {
        let cellRegistration = UICollectionView
            .CellRegistration<LabelCell, Int> { cell, indexPath, item in
        
                cell.label.text = "\(item)"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collection,
                                                                      cellProvider: { collection, indexPath, item in
                                                                        return collection.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                                                                        for: indexPath,
                                                                                                                        item: item)
            
        })
        
        //Initialize with data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems((0...100).map({$0}))
        dataSource.apply(snapshot)
    }
}
