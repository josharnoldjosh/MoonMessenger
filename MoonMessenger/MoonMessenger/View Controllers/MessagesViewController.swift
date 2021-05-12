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


class MessagesViewController : UIViewController {
    
    var profilePicture:UIImageView!
    var username:UILabel = UILabel.body()
    var back:BackButton!
    private var convo:ConvoItem!
    
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
    }
    
    func setupUI() {
        profilePicture = UIImageView()
        profilePicture.image = convo.image
        profilePicture.backgroundColor = .darkShadow
        profilePicture.layer.cornerRadius = 60/2
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        view.addSubview(profilePicture)
        
        username.text = convo.username
        username.font = .caption
        view.addSubview(username)
        
        back = BackButton(tap: {
            self.hero.modalAnimationType = .slide(direction: .right)
            self.hero.dismissViewController()
//            self.dismiss(animated: true, completion: nil)
        })
        view.addSubview(back)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func goToHome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = ConvoViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.heroModalAnimationType = .zoomOut
            self.present(vc, animated: true, completion: nil)
        }
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

