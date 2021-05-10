//
//  TextButton.swift
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


class TextButton : UIView {
    
    let button = UIButton()
    
    init(_ title:String, onTap: @escaping () -> Void) {
        super.init(frame: .zero)
        
        // Button
        addSubview(button)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .caption
        button.titleLabel?.numberOfLines = 0
        button.alpha = 0.5
        button.titleLabel?.textAlignment = .center
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
    
    func animateDown(duration:TimeInterval=0.2, scale:CGFloat=0.8) {
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
struct TextButtonContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make {
                let button = TextButton("Already have an account?") {
                    
                }
                let vc = UIViewController()
                vc.view.backgroundColor = .background
                vc.view.addSubview(button)
                button.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.equalTo(100)
                    make.height.equalTo(48)
                }
                return vc
            }
        }
    }
}

