//
//  ShinyButton.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/10/21.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit
import Closures
import Preview
import PopBounceButton


class ShinyButton : PopBounceButton {
    
    let lightGradient = CAGradientLayer()
    let gradient = CAGradientLayer()
    let button = UILabel.body()
    
    init(_ title:String, onTap: @escaping () -> Void) {
        super.init(frame: .zero)
        
        // Layer
        layer.insertSublayer(gradient, at: 0)
        
        // Gradients
        gradient.colors = [UIColor.primary.cgColor, UIColor.secondary.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        lightGradient.startPoint = CGPoint(x: 0, y: 0)
        lightGradient.endPoint = CGPoint(x: 1, y: 1)
        lightGradient.colors = [UIColor(white: 1, alpha: 0.3).cgColor, UIColor.clear.cgColor]
        layer.addSublayer(lightGradient)
        
        // Button
        addSubview(button)
        button.text = title
        button.font = .caption
        button.textColor = UIColor(white: 1, alpha: 1)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.layer.masksToBounds = true
                
        self.addAction(UIAction(handler: { tap in
            Impact.button()
            onTap()
        }), for: .touchUpInside)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let cornerRadius = (self.frame.height) / 2
        layer.cornerRadius = cornerRadius
        gradient.cornerRadius = cornerRadius
        lightGradient.cornerRadius = cornerRadius
        gradient.frame = bounds
        lightGradient.frame = bounds
    }
}


@available(iOS 13.0, *)
struct ShinyButtonContentView_Previews : PreviewProvider {
    static var previews : some View {
        Preview.make {
            let button = ShinyButton("Signup") {
                
            }
            let vc = UIViewController()
            vc.view.backgroundColor = .background
            vc.view.addSubview(button)
            button.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(150)
                make.height.equalTo(48)
            }
            return vc
        }
    }
}

