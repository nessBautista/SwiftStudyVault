//
//  HomeViewController.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 13/06/21.
//

import UIKit
import Combine
class HomeViewController: UIViewController {
    enum Section {
        case main
    }
    var homeViewModel: HomeViewModel = HomeViewModel(collection: [])
    var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Variables
    var dataSource: UICollectionViewDiffableDataSource<Section, FeedItemViewModel>! = nil
    var collection: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        UIConfig()
        dataSourceConfig()
        //Request
        self.homeViewModel.loadFeedItems()
        //Bind
        self.homeViewModel.homeCollection
            .receive(on: DispatchQueue.main)
            .sink { completion in
            print(completion)
        } receiveValue: { feedItems in
            if feedItems.count > 0 {
                self.insertItems(feedItems)
            }
        }.store(in: &subscriptions)
        
//        self.homeViewModel.reloadPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] indexPath in
//                if var snapShot = self?.dataSource.snapshot(),
//                   let item = self?.dataSource.itemIdentifier(for: indexPath) {
//                    snapShot.reloadItems([item])
//                    self?.dataSource.apply(snapShot, animatingDifferences: true)
//                }
//            }
//            .store(in: &subscriptions)
    }
    
    // UI config
    private func UIConfig(){
        self.collection = UICollectionView(frame: view.bounds,
                                           collectionViewLayout: self.getSimpleLayout())
        collection?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collection)
    }
    private func getSimpleLayout()-> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(326))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems:[item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func dataSourceConfig() {
        let cellRegistration = UICollectionView.CellRegistration<HomeItemCell, FeedItemViewModel>
            .init(cellNib: UINib(nibName: "HomeItemCell", bundle: nil)) {  cell, indexPath, item in
                cell.load(item)
                cell.lblLocation.text = "\(indexPath.row)"
                self.homeViewModel.fetchImage(idx: indexPath)
        }
        self.collection.prefetchDataSource = self
        self.collection.delegate = self
        dataSource = UICollectionViewDiffableDataSource<Section, FeedItemViewModel>(
            collectionView: collection,
            cellProvider: { collection, indexPath, item in
                let cell = collection.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
                return cell
            
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedItemViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.homeViewModel.homeCollection.value)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func insertItems(_ data: [FeedItemViewModel]){
        //Initialize with data
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedItemViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.homeViewModel.items.count - 1 {
            self.homeViewModel.loadFeedItems()
        }
        print("will display \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.homeViewModel.cancelFetchImage(idx: indexPath)
    }
}
extension HomeViewController: UICollectionViewDataSourcePrefetching {
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("---->\(indexPaths)")
        for row in indexPaths {
            self.homeViewModel.fetchImage(idx: row)
        }
        
    }
    
}
