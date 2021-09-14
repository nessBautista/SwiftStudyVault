//
//  LabelCell.swift
//  ModernLayouts
//
//  Created by Nestor Hernandez on 13/06/21.
//

import UIKit

class LabelCell: UICollectionViewCell {
    static let reuseIdentifier = "label-cell-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension LabelCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        backgroundColor = .white
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
