//
//  UsernameHeader.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/20/21.
//

import UIKit
import SnapKit


class EmptyUsernameHeader : UICollectionReusableView {
    static var reuseIdentifier:String = "username"
}


class UsernameHeader : UICollectionReusableView {
    
    static var reuseIdentifier:String = "usernameHeader"
    var label:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text:String, style:ChatStyle = ChatStyle()) {
        label.text = text
        label.textColor = style.username.color
        label.font = style.username.font
        
        if style.avatar.showIncomingAvatar == true {
            label.snp.removeConstraints()
            label.snp.makeConstraints { make in
                make.top.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(4)
                make.left.equalToSuperview().inset(style.avatar.scale/2)
            }
        }
    }
}

