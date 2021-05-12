//
//  MessagesViewController.swift
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
import IHKeyboardAvoiding


class MessagesViewController : UIViewController {
    
    var profilePicture:UIImageView!
    var username:UILabel = UILabel.body()
    var back:BackButton!
    private var convo:ConvoItem!
    
    private var chatView:ChatView!
    private var input:ChatInputTextField!
    
    init(convo: ConvoItem) {
        super.init(nibName: nil, bundle: nil)
        self.convo = convo
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .slide(direction: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        snap()
        
        KeyboardAvoiding.avoidingView = self.view
        view.addTapGesture { tap in
            self.view.endEditing(true)
        }
    }
    
    func setupUI() {
        profilePicture = UIImageView()
        profilePicture.image = convo.image
        profilePicture.backgroundColor = .darkShadow
        profilePicture.layer.cornerRadius = 60/2
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        view.addSubview(profilePicture)
        
        username.font = .caption
        username.text = convo.username
        view.addSubview(username)
        
        back = BackButton(tap: {
            self.hero.modalAnimationType = .slide(direction: .right)
            self.hero.dismissViewController()
        })
        view.addSubview(back)
        
        var style = ChatStyle()
        style.seen = SeenStyle(enableSeen: false, scale: 0, avatorImage: UIImage(), tintColor: .white)
        style.outgoing.gradient.colors = [.primary, .secondary]
        style.incoming.gradient.colors = [.lightShadow]
        style.incoming.label.textColor = .white
        style.avatar.avatorImage = convo.image
        chatView = ChatView(style: style, frame: .zero)
        chatView.backgroundColor = .background
        view.addSubview(chatView)
        
        input = ChatInputTextField(send: { text in 
            self.chatView.addMessages([
                Message(text: text, origin: .outgoing, date: Date(), delivered: true, seen: true, error: false),
            ])
        })
        view.addSubview(input)
    }
    
    func snap() {
        profilePicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(self.profilePicture.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
        back.snp.makeConstraints { make in
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.width.equalTo(40)
        }
        
        chatView.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).offset(20)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.input.snp.top).offset(-5)
//            make.bottom.equalToSuperview().offset(-60)
        }
        
        input.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatView.addMessages([
            Message(text: "Hey!", origin: .outgoing, date: Date(), delivered: true, seen: true, error: false),
            Message(text: "How's it going?", origin: .outgoing, date: Date(), delivered: true, seen: true, error: false),
            Message(text: "Great, hby?", origin: .incoming, date: Date(), delivered: true, seen: true, error: false),
            Message(text: "What's new?", origin: .incoming, date: Date(), delivered: true, seen: true, error: false),
        ])
    }
}


@available(iOS 13.0, *)
struct MessagesViewControllerContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(
                MessagesViewController(
                            convo: ConvoItem(id: UUID(), username: "KAKASHI", image: UIImage(named: "Kakashi") ?? UIImage(), lastMessageDate: Date(), lastMessageText: "Hello")
            ))
        }
    }
}

