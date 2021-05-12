//
//  BackButton.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/12/21.
//

import Foundation
import UIKit
import PopBounceButton
import Preview
import SwiftUI
import Closures


class BackButton : PopBounceButton {
    
    init(tap: @escaping () -> ()) {
        super.init()        
        imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(named: "Back") ?? UIImage(), for: .normal)
        self.addAction(UIAction(handler: { UIAction in
            tap()
        }), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@available(iOS 13.0, *)
struct BackButtonContentView_Previews : PreviewProvider {
    static var previews : some View {
        Preview.make {
            let button = BackButton() {
                
            }
            let vc = UIViewController()
            vc.view.backgroundColor = .background
            vc.view.addSubview(button)
            button.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            return vc
        }
    }
}

