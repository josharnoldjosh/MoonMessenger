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


class ShinyButton : UIView {
    
    let lightGradient = CAGradientLayer()
    let gradient = CAGradientLayer()
    let button = UIButton()
    
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
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .body
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Start touch
        button.on(.touchDown) { a, b in
            self.animateDown()
        }
                
        // Succeed touch
        button.on(.touchUpInside) { a, b in
            self.animateUp()
            Impact.button()
            onTap()
        }
        
        // Cancel touch
        button.on([.touchCancel, .touchUpOutside, .touchDragOutside, .touchDragExit]) { a, b in
            self.animateUp()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let cornerRadius = frame.height / 2
        layer.cornerRadius = cornerRadius
        gradient.cornerRadius = cornerRadius
        lightGradient.cornerRadius = cornerRadius
        gradient.frame = bounds
        lightGradient.frame = bounds
    }
    
    func animateDown(duration:TimeInterval=0.4, scale:CGFloat=0.8) {
        UIView.animate(
            withDuration: duration,
                    delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
                    options: [],
                    animations: {
                        self.transform = CGAffineTransform(scaleX: scale, y: scale)
                    },
                    completion: nil
                )
    }
    
    func animateUp(duration:TimeInterval = 0.8) {
        UIView.animate(
            withDuration: duration,
                    delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.9,
                    options: [],
                    animations: {
                        self.transform = .identity
                    },
                    completion: nil
                )
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

