import UIKit

public class PhotoCell: UITableViewCell {
    private var imageview: UIImageView!

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageview.image = UIImage(named: "nature")
        self.contentView.addSubview(self.imageview)
        imageview.anchor(top: self.contentView.topAnchor,
                              leading: self.contentView.leadingAnchor,
                              trailing: self.contentView.trailingAnchor,
                              bottom: self.contentView.bottomAnchor)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func load(image: UIImage?) {
        imageview.image = image
    }
}
public extension UIImageView {
    func anchor(top: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        //Size
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
}

