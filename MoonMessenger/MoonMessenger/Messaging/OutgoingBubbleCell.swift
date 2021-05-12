//
//  OutgoingBubbleCell.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/4/21.
//

import UIKit
import SnapKit


class OutgoingBubbleCell : BubbleCell {
            
    override init(frame: CGRect) {
        super.init(frame: frame)
                        
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(25)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        bubbleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.label).inset(-10)
            make.bottom.equalTo(self.label).offset(10)
            make.left.equalTo(self.label).inset(-15)
            make.right.equalTo(self.label).offset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class OutgoingTop : OutgoingBubbleCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
        self.corners = [.topLeft, .bottomLeft, .topRight]
    }
}


class OutgoingMiddle : OutgoingBubbleCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
        self.corners = [.topLeft, .bottomLeft]
    }
}


class OutgoingBottom : OutgoingBubbleCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
        self.corners = [.topLeft, .bottomLeft, .bottomRight]
    }
}
