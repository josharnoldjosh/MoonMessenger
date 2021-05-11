//
//  TextField.swift
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


class TextField : UIView {
    
    var imageView:UIImageView!
    var textfield:UITextField!
    var line:UIView! = UIView()
    
    init(imageName:String, placeholder:String) {
        super.init(frame: .zero)
        
        imageView = UIImageView(image: UIImage(named: imageName) ?? UIImage())
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        textfield = UITextField()
        textfield.tintColor = UIColor(white: 1.0, alpha: 0.5)
        textfield.font = .body
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor(white: 1, alpha: 0.5), .font : UIFont.body])
        textfield.textColor = .white
        addSubview(textfield)
        
        line.backgroundColor = UIColor(white: 1, alpha: 0.2)
        addSubview(line)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.centerY.equalToSuperview().offset(-2)
        }
        
        textfield.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(self.imageView.snp.right).offset(10)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(30)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func secure() {
        textfield.isSecureTextEntry = true
    }
    
    func name() {
        textfield.autocorrectionType = .yes
        textfield.autocapitalizationType = .words
    }
    
    func email() {
        textfield.keyboardType = .emailAddress
        textfield.autocorrectionType = .no        
        textfield.autocapitalizationType = .none
    }
    
    func hideLine() {
        line.alpha = 0
    }
}


@available(iOS 13.0, *)
struct TextFieldContentView_Previews : PreviewProvider {
    static var previews : some View {
        Preview.make {
            let button = TextField(imageName: "UserIcon", placeholder: "Name")
            let vc = UIViewController()
            vc.view.backgroundColor = .background
            vc.view.addSubview(button)
            button.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview().inset(20)
                make.height.equalTo(40)
            }
            return vc
        }
    }
}

