//
//  ResizableGradientView.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/3/21.
//

import UIKit


/// A view with a gradient that responds to autolayout
final class GradientView : UIView {
    
    // Override the default layer type for this UIView to CAGradientLayer
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    // Create a reference to the said view
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    
    private var _colors:[UIColor] = []
    
    var colors:[UIColor] {
        get {
            return self._colors
        }
        set {
            self._colors = newValue
            self.cgColors = []
            for i in newValue {
                self.cgColors.append(i.cgColor)
            }
        }
    }
    
    private var cgColors:[CGColor] = []
    
    override func didMoveToSuperview() {
        updateShape()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShape()
    }
    
    func updateShape() {
        DispatchQueue.main.async {
            self.gradientLayer.backgroundColor = UIColor.systemBackground.cgColor
            self.gradientLayer.colors = self.cgColors
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
}
