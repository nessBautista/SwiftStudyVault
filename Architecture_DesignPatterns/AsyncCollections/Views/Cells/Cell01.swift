//
//  Cell01.swift
//  AsyncCollections
//
//  Created by Nestor Hernandez on 03/06/21.
//

import UIKit

class Cell01: UITableViewCell {
    var imageview: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let imageView = UIImageView(frame: self.contentView.frame)
        self.imageview = imageView
        self.imageview.image = UIImage(named: "nature")
        self.contentView.addSubview(self.imageview)
        self.imageview.anchor(top: self.contentView.topAnchor,
                              leading: self.contentView.leadingAnchor,
                              trailing: self.contentView.trailingAnchor,
                              bottom: self.contentView.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        self.imageview.image = nil
        self.imageview.contentMode = .scaleAspectFit
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
