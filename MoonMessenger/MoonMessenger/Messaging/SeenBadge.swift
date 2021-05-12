//
//  SeenBadge.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 4/18/21.
//

import UIKit


final class SeenBadge : UICollectionReusableView {
        
    static var reuseIdentifier:String = "seenBadge"
    private var imageView:UIImageView = UIImageView(image: UIImage(systemName: "person.crop.circle") ?? UIImage())
    private var style:ChatStyle = ChatStyle()
    //    private var errorView:UIImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.tintColor = .systemGray5
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        updateStyle(style: self.style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStyle(style:ChatStyle = ChatStyle()) {
        imageView.image = style.seen.avatorImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = style.seen.tintColor
    }
}
