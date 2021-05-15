//
//  EditChannelViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/15/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import Closures
import PopBounceButton


class EditChannelViewController : UIViewController {
    
    var back:BackButton!
    var profilePicture:PopBounceButton!
    var textfield:TextField!
    var instructions:UILabel = UILabel.body()
    var privateKey:PopBounceButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
        self.hero.isEnabled = true
        self.view.addTapGesture { tap in
            self.view.endEditing(true)
        }
        setupUI()
        snap()
    }
    
    func setupUI() {
        back = BackButton(tap: {
            self.hero.modalAnimationType = .zoom
            self.hero.dismissViewController()
        })
        view.addSubview(back)
        
        profilePicture = PopBounceButton()
        profilePicture.addAction(UIAction(handler: { tap in
            Impact.button()
            // Show edit profile logic
        }), for: .touchUpInside)
        profilePicture.imageView?.contentMode = .scaleAspectFit
        profilePicture.setImage(UIImage(named: "UserIcon") ?? UIImage(), for: .normal)
        profilePicture.backgroundColor = .lightShadow
        profilePicture.layer.cornerRadius = 70 / 2
        profilePicture.layer.masksToBounds = true
        view.addSubview(profilePicture)
        
        textfield = TextField(imageName: "LockIcon", placeholder: "Channel Name")
        textfield.key()
        textfield.textfield.font = .mini
        view.addSubview(textfield)
        
        instructions.text = "Edit your channel’s name and photo."
        instructions.alpha = 0.4
        view.addSubview(instructions)
        
        privateKey = PopBounceButton()
        privateKey.setTitle("3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy", for: .normal)
        privateKey.titleLabel?.font = .mini
        privateKey.titleLabel?.alpha = 0.5
        privateKey.addAction(UIAction(handler: { tap in
            // Show tap
            Impact.hint()
        }), for: .touchUpInside)
        view.addSubview(privateKey)
    }
    
    func snap() {
        back.snp.makeConstraints { make in
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.width.equalTo(40)
        }
  
        profilePicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
            make.top.equalTo(self.back.snp.bottom)
        }
        
        textfield.snp.makeConstraints { make in
            make.top.equalTo(self.profilePicture.snp.bottom).offset(20)
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        instructions.snp.makeConstraints { make in
            make.top.equalTo(self.textfield.snp.bottom).offset(40)
            make.width.equalTo(250)
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        
        privateKey.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.lessThanOrEqualToSuperview()
        }
    }
}

@available(iOS 13.0, *)
struct EditChannelContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(EditChannelViewController())
        }
    }
}
