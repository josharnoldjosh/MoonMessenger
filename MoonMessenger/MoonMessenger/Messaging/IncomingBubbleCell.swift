//
//  IncomingBubbleCell.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/4/21.
//

import UIKit
import SnapKit


class IncomingBubbleCell : BubbleCell {
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(25)
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

class IncomingTop : IncomingBubbleCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
        self.corners = [.topRight, .bottomRight, .topLeft]
    }
}

class IncomingMiddle : IncomingBubbleCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
        self.corners = [.topRight, .bottomRight]
    }
}

class IncomingBottom : IncomingBubbleCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()        
        self.corners = [.topRight, .bottomRight, .bottomLeft]
    }
}
