//
//  DateView.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/8/21.
//

import UIKit
import SnapKit


class EmptyHeader : UICollectionReusableView {    
    static var reuseIdentifier:String = "spacer"
}


class DateHeader : UICollectionReusableView {
    
    static var reuseIdentifier:String = "dateHeader"
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
        label.textAlignment = .center
        label.textColor = style.dateStamp.color
        label.font = style.dateStamp.font
        
        if style.avatar.showIncomingAvatar == true {
            label.snp.removeConstraints()
            label.snp.makeConstraints { make in
                make.top.bottom.left.equalToSuperview()
                make.right.equalToSuperview().offset(-style.avatar.scale)
            }
        }
    }
}
