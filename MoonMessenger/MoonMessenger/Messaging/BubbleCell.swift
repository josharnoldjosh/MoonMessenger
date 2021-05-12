//
//  BubbleCell.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 12/29/20.
//

import UIKit
import SnapKit


class BubbleCell : UICollectionViewCell {
    
    var bubbleView:UIView!
    var gradientView:GradientView!
    var label:UILabel!
    var message:Message?
    
    var text:String = "" {
        didSet {
            guard label != nil else {return}
            label.text = text
        }
    }
    var corners:UIRectCorner = .allCorners {
        didSet {
            self.roundCorners(corners: self.corners)            
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set the initial position of the gradient
    override func layoutSubviews() {
        self.updateGradient()
        self.roundCorners(corners: self.corners)
        super.layoutSubviews()
    }
}



extension BubbleCell {
    /// Setup our UI and our constraints
    func setupUI() {
        
        contentView.layer.masksToBounds = true
                
        // The shape of the bubble used implicitly as a "mask"
        bubbleView = UIView()
        bubbleView.layer.cornerRadius = 4
        bubbleView.layer.cornerCurve = .continuous        
        bubbleView.clipsToBounds = true
        contentView.addSubview(bubbleView)
        
        // The gradient background
        gradientView = GradientView()
        bubbleView.addSubview(gradientView)
                                          
        // The text displayed on the bubble
        label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
    }
}


/// Public Functions
extension BubbleCell {
    
    /// Update the style of the chat bubble
    public func applyStyle(style:ChatUserStyle) {
        
        if style.gradient.colors.count <= 1 {
            self.gradientView.alpha = 0
        }else{
            self.gradientView.alpha = 1
        }
        
        self.gradientView.colors = style.gradient.colors
        
        if style.gradient.colors.count >= 1 && style.gradient.colors.count <= 2 {
            self.bubbleView.backgroundColor = style.gradient.colors[0]
        }
        
        self.label.textColor = style.label.textColor
        self.label.font = style.label.font
    }
    
    /// Update the Gradient
    public func updateGradient() {
        guard let mainView = self.superview?.superview?.superview else {return}
        DispatchQueue.main.async {
            self.gradientView.frame = CGRect(
                x: 0,
                y: mainView.convert(CGPoint.zero, to: self.contentView).y,
                width: mainView.frame.width,
                height: mainView.frame.height
            )
        }
    }
    
    /// Round our corners
    public func roundCorners(corners:UIRectCorner) {
        // TODO: Update me?!
        DispatchQueue.main.async {
            let maskPath = UIBezierPath(roundedRect: self.bubbleView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 17.0, height: 0.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            self.bubbleView.layer.mask = maskLayer // updates the mask
        }
    }
}


