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


class InputViewWrapper : UIView {
    
    
    var input:ChatInputTextField!
    
    init(success: @escaping (_ send:String) -> ()) {
        super.init(frame: .zero)
        
        input = ChatInputTextField(send: { text in
            success(text)
        })
        
        addSubview(input)
                
        
        input.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MessagesViewController : UIViewController {
    
    var profilePicture:PopBounceButton!
    var username:UILabel = UILabel.body()
    var back:BackButton!
    private var convo:ConvoItem!
    
    private var chatView:ChatView!
    private var input:InputViewWrapper!
    
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
        
        KeyboardAvoiding.avoidingView = self.input
        view.addTapGesture { tap in
            self.view.endEditing(true)
        }
        
        chatView.alpha = 0
        username.alpha = 0
    }
    
    func setupUI() {
        profilePicture = PopBounceButton()
        profilePicture.setImage(convo.image, for: .normal)
        profilePicture.backgroundColor = .darkShadow
        profilePicture.layer.cornerRadius = 50/2
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.addAction(UIAction(handler: { tap in
            self.editChannelDetails()
        }), for: .touchUpInside)
        view.addSubview(profilePicture)
        
        username.font = .caption
        username.text = convo.username
        username.alpha = 0.5
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
        style.outgoing.label.font = .caption
        style.incoming.label.font = .caption
        chatView = ChatView(style: style, frame: .zero)
        
        chatView.backgroundColor = .background
        chatView.collectionView.contentInset = UIEdgeInsets(top: 130, left: 0, bottom: 70, right: 0)
        view.insertSubview(chatView, at: 0)
    
        chatView.didScroll = { offset in
            if offset.y <= -130 {
                UIView.animate(withDuration: 0.2) {
                    self.username.alpha = 0.5
                }
            }else{
                guard self.chatView.data.snapshot().itemIdentifiers.count > 0 else {return}
                UIView.animate(withDuration: 0.2) {
                    self.username.alpha = 0
                }
            }
        }
    
        input = InputViewWrapper(success: { text in
            self.sendMessage(text: text)
        })
        
        input.input.textfield.onEditingEnded {
            self.chatView.scrollToBottom()
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.12, options: []) {
                self.chatView.collectionView.contentInset.bottom -= 300
            } completion: { done in
                
            }
        }.onEditingBegan {
            self.chatView.collectionView.contentInset.bottom += 300
            self.chatView.scrollToBottom()
        }
        view.addSubview(input)        
    }
    
    func snap() {
        profilePicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
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
//            make.edges.equalTo(self.view.safeAreaLayoutGuide)
            make.edges.equalToSuperview()
        }
        
        input.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(55)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                        
        UIView.animate(withDuration: 0.5, delay: 0.15, options: []) {
            self.chatView.alpha = 1
        } completion: { done in
            
        }
    }
    
    func editChannelDetails() {
        let vc = EditChannelViewController()
        vc.heroModalAnimationType = .zoomOut
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func sendMessage(text: String) {
        self.chatView.addMessages([
            Message(text: text, origin: .outgoing, date: Date(), delivered: true, seen: true, error: false),
        ])
        
        Backend.shared.sendMessage(text: text, id: convo.id.uuidString)        
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

