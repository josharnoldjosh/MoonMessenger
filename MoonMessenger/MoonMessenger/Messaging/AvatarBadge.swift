//
//  AvatarBadge.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 4/18/21.
//

import UIKit
import SnapKit


class EmptyAvatar : UICollectionReusableView {
    static var reuseIdentifier:String = "avatarBadgeEmpty"
}


class AvatarBadge : UICollectionReusableView {
        
    static var reuseIdentifier:String = "avatarBadge"
    var imageView:UIImageView = UIImageView(image: UIImage(systemName: "person.crop.circle") ?? UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAvatar(style:ChatStyle = ChatStyle()) {
        imageView.image = style.avatar.avatorImage
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = style.avatar.tintColor
        imageView.layer.cornerRadius = style.avatar.scale / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
}
