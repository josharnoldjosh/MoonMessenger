//
//  ChatInputTextField.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/12/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import Closures
import PopBounceButton


class ChatInputTextField : UIView {
    
    var textfield:UITextField!
    var sendButton:PopBounceButton = PopBounceButton()
    
    init(send: @escaping (_ text:String) -> ()) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 0.17, green: 0.18, blue: 0.23, alpha: 1.00)
        layer.cornerRadius = 45 / 2
        layer.masksToBounds = true
        setupUI()
        snap()
        
        sendButton.addAction(UIAction(handler: { UIAction in
            Impact.hint()
            if (self.textfield.text != "") {
                send(self.textfield.text ?? "")
            }
            self.textfield.text = ""
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        textfield = UITextField()
        textfield.font = .caption
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "Type your message here...", attributes: [.foregroundColor : UIColor(white: 1, alpha: 0.5), .font : UIFont.caption])
        textfield.tintColor = .white                
        addSubview(textfield)
                
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.setImage(UIImage(named: "SendA") ?? UIImage(), for: .normal)
        sendButton.setImage(UIImage(named: "SendB") ?? UIImage(), for: .highlighted)
        addSubview(sendButton)
    }
    
        
    func snap() {
        textfield.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(sendButton.snp.left)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(5)
            make.width.equalTo(40)
        }
    }
}


@available(iOS 13.0, *)
struct ChatInputTextFieldContentView_Previews : PreviewProvider {
    static var previews : some View {
        Preview.make {
            let button = ChatInputTextField() { text in }
            let vc = UIViewController()
            vc.view.backgroundColor = .background
            vc.view.addSubview(button)
            button.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(45)
            }
            return vc
        }
    }
}

