//
//  ProfileViewController.swift
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
import Firebase


final class ProfileViewController : UIViewController {
    
    var back:BackButton!
    var username:TextField = TextField(imageName: "", placeholder: "Username")
    var profilePicture:PopBounceButton!
    private var moon:UIImageView = UIImageView(image: UIImage(named: "ProfileMoon") ?? UIImage())
    var logout:ImageButton!
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.username.textfield.text = User.username
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.moon.transform = .identity
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        User.username = self.username.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Username"
        Backend.shared.updateUsername()
    }
    
    func setupUI() {
        back = BackButton(tap: {            
            self.hero.modalAnimationType = .slide(direction: .left)
            self.hero.dismissViewController()
        })
        back.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        view.addSubview(back)
                
        username.textfield.font = .large
        username.alpha = 0.8
        username.hideLine()
        username.key()
        username.textfield.textAlignment = .left
        view.addSubview(username)
        
        moon.contentMode = .scaleAspectFill
        moon.transform = CGAffineTransform(translationX: 100, y: 0)
        view.addSubview(moon)
        
        profilePicture = PopBounceButton()
        profilePicture.addAction(UIAction(handler: { tap in
            Impact.button()
            // Show edit profile logic
        }), for: .touchUpInside)
        profilePicture.imageView?.contentMode = .scaleAspectFit
        profilePicture.setImage(UIImage(named: "UserIcon") ?? UIImage(), for: .normal)
        profilePicture.backgroundColor = .lightShadow
        profilePicture.layer.cornerRadius = 80 / 2
        profilePicture.layer.masksToBounds = true
        view.addSubview(profilePicture)
        
        
        logout = ImageButton(imageNames: ["LogoutA", "LogoutB"], onTap: {
            // logout
            try? Auth.auth().signOut()
        })
        logout.contentMode = .scaleAspectFit
        view.addSubview(logout)
        
    }
    
    func snap() {
        back.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.width.equalTo(40)
        }

        username.snp.makeConstraints { make in
            make.top.equalTo(self.profilePicture.snp.bottom).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.width.lessThanOrEqualToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
        moon.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(60)
        }
        
        profilePicture.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(self.back.snp.bottom).offset(20)
            make.width.height.equalTo(80)
        }
        
        logout.snp.makeConstraints { make in
            make.bottom.left.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }
}

@available(iOS 13.0, *)
struct ProfileViewContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(ProfileViewController())
        }
    }
}
