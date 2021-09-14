//
//  HomeItemCell.swift
//  PhotoSharingApp
//
//  Created by Nestor Hernandez on 14/06/21.
//

import UIKit
import Combine
class HomeItemCell: UICollectionViewCell, ViewModelLoadable {
    static let reuseIdentifier = "HomeItemCell"
    
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    typealias ViewModel = FeedItemViewModel
    
    private(set) var viewModel: FeedItemViewModel?
    private var homeItemSubscription: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        // Initialization code
    }
    
    override func prepareForReuse() {
        homeItemSubscription = nil
    }

    func load(_ viewModel: FeedItemViewModel) {
        // Set ViewModel
        self.viewModel = viewModel
        // Configure UI
        self.lblUser.text = self.viewModel?.photo.user.username
        self.imgPhoto.contentMode = .scaleAspectFit
        if let image = viewModel.image {
            self.imgPhoto.image = image
        } else {
            homeItemSubscription = self.viewModel?.$image
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { photo in
                    
                    self.imgPhoto.image = photo
                })
        }
    }
}


