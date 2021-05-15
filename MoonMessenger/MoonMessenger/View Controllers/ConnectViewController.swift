//
//  ConnectViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/12/21.
//


import Foundation
import UIKit
import SwiftUI
import Preview
import Closures
import Firebase
import JGProgressHUD


class ConnectViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var titleLabel:UILabel = UILabel.title(text: "Uplink")
    var descLabel:UILabel = UILabel.body()
    
    var signup:ShinyButton!
    var login:TextButton!
    var moonBackground:UIImageView = UIImageView(image: UIImage(named: "LoginMoon")!)
        
    var email:TextField = TextField(imageName: "AtIcon", placeholder: "Email")
    var password:TextField = TextField(imageName: "LockIcon", placeholder: "Username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        hero.isEnabled = true
        view.addTapGesture { tap in
            self.view.endEditing(true)
        }
        
        moonBackground.contentMode = .scaleAspectFill
        moonBackground.alpha = 0
        moonBackground.transform = CGAffineTransform(translationX: 0, y: -100)
        view.addSubview(moonBackground)
                
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        view.addSubview(titleLabel)
        
        descLabel.alpha = 0
        descLabel.font = .caption
        descLabel.text = "Choose a username and begin an anonymous session."
        descLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        view.addSubview(descLabel)
        
        
        signup = ShinyButton("Continue") {
            self.loginUser()
        }
        signup.hero.id = "signup"
        signup.hero.modifiers = [.duration(0.5)]
        view.addSubview(signup)
        
        login = TextButton("Don't have an account?") {
            self.goToSignup()
        }
        login.hero.id = "bottomButton2"
        login.hero.modifiers = [.duration(0.3)]
        login.alpha = 0
        view.addSubview(login)
        
        email.transform = CGAffineTransform(translationX: -20, y: 0)
        email.alpha = 0
        email.email()
        email.hideLine()
        view.addSubview(email)
        
        password.transform = CGAffineTransform(translationX: -20, y: 0)
        password.alpha = 0
        password.name()
        view.addSubview(password)
        
        // Snap
                        
        moonBackground.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.lessThanOrEqualToSuperview()
        }
        
        email.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(100)
            make.width.equalTo(225)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        password.snp.makeConstraints { make in
            make.top.equalTo(self.descLabel.snp.bottom).offset(40)
            make.width.equalTo(225)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }

        signup.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(46)
            make.center.equalToSuperview()
//            make.top.equalTo(self.password.snp.bottom).offset(50)
        }
        
        login.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 0.8,
                    delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
                    options: [],
                    animations: {
                        self.titleLabel.alpha = 1
                        self.titleLabel.transform = .identity
                        self.descLabel.alpha = 0.5
                        self.descLabel.transform = .identity
                        self.moonBackground.alpha = 1
                        self.moonBackground.transform = .identity
//                        self.email.alpha = 1
                        self.email.transform = .identity
                        self.password.alpha = 1
                        self.password.transform = .identity
                    },
                    completion: nil
                )
    }
    
    func loginUser() {
        
        view.isUserInteractionEnabled = false
        
        User.username = password.textfield.text ?? "User"
                        
        let hud = JGProgressHUD.init(style: JGProgressHUDStyle.dark)
        hud.textLabel.text = "Linking"
        hud.textLabel.font = .caption
        hud.show(in: self.view)
        
        Auth.auth().signInAnonymously { Result, error in
            hud.dismiss()
            self.view.isUserInteractionEnabled = true
            
            if error == nil {
                
                Backend.shared.updateUsername()
                
                // Fade out
                self.fadeOut()
                
                // Update username
                Backend.shared.updateUsername()
                                
                // GO to welcome view controller
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    hud.dismiss()
                    let vc = WelcomeViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                // TODO: Show error
            }
        }
    }
    
    func goToSignup() {
        fadeOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = SignupViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func fadeOut() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.25,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.7,
                    options: [],
                    animations: {
                        self.moonBackground.alpha = 0
                        self.moonBackground.transform = .init(translationX: 0, y: -100)
                        self.email.transform = .init(translationX: 15, y: 0)
                        self.password.transform = .init(translationX: 20, y: 0)
                        self.email.alpha = 0
                        self.password.alpha = 0
                    },
                    completion: nil
                )
        
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 0
            self.descLabel.alpha = 0
            self.signup.alpha = 0
            self.login.alpha = 0
        }
    }
}


@available(iOS 13.0, *)
struct ConnectViewControllerContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(ConnectViewController())
        }
    }
}

