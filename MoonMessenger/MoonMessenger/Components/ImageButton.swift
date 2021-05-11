//
//  ImageButton.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/11/21.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit
import Closures
import Preview


class ImageButton : UIView {
    
    let button = UIButton()
            
    init(imageNames:[String], onTap: @escaping () -> Void) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard imageNames.count >= 2 else {return}
        button.setImage(UIImage(named: imageNames.first ?? "") ?? UIImage(), for: .normal)
        button.setImage(UIImage(named: imageNames.last ?? "") ?? UIImage(), for: .highlighted)
        button.onTap {
            onTap()
            Impact.button()
        }.on(.touchDown) { a, b in
            Impact.hint()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@available(iOS 13.0, *)
struct ImageButtonContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make {
                let button = ImageButton(imageNames: ["ButtonCircleA", "ButtonCircleC"]) {
                    
                }
                let vc = UIViewController()
                vc.view.backgroundColor = .background
                vc.view.addSubview(button)
                button.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.equalTo(200)
                    make.height.equalTo(200)
                }
                return vc
            }
        }
    }
}

