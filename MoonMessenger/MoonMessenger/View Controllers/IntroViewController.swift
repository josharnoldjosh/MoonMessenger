//
//  IntroViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/9/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview


class IntroViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var moonImageView = UIImageView(image: UIImage(named: "Moon") ?? UIImage())
    var backgroundImage = UIImageView(image: UIImage(named: "NightSky") ?? UIImage())
    var titleLabel:UILabel = UILabel.title()
    var bodyLabel:UILabel = UILabel.body()
    var signup:ShinyButton!
    var login:TextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        view.backgroundColor = .background
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.hero.id = "background"
        backgroundImage.hero.modifiers = [.duration(2.0)]
        view.addSubview(backgroundImage)
        
        moonImageView.hero.id = "moon"
        moonImageView.hero.modifiers = [.duration(2.0)]
        moonImageView.transform = CGAffineTransform.init(rotationAngle: -1.35)
        view.addSubview(moonImageView)
        
        titleLabel.text = "Moon."
        titleLabel.alpha = 0
        titleLabel.hero.id = "title"
        view.addSubview(titleLabel)
        
        bodyLabel.text = "Beautiful, secure, messaging."
        bodyLabel.alpha = 0
        view.addSubview(bodyLabel)
        
        signup = ShinyButton("Signup") {
            self.signupUser()
        }
        signup.hero.id = "signup"
        signup.alpha = 0
        view.addSubview(signup)
        
        login = TextButton("Have an account?") {
            self.loginUser()
        }
        login.hero.id = "login"
        login.alpha = 0
        view.addSubview(login)
         
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moonImageView.snp.makeConstraints { make in
            make.width.height.equalTo(90)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(120)
        }
                    
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.bottom.equalTo(self.bodyLabel.snp.top)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.signup.snp.top).offset(-50)
        }
        
        signup.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(46)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.login.snp.top).offset(-5)
        }
        
        login.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
        
        signup.transform = CGAffineTransform(translationX: 0, y: 20)
        login.transform = CGAffineTransform(translationX: 0, y: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0) {
            self.titleLabel.alpha = 1
            self.bodyLabel.alpha = 0.5
        }
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.5, options: []) {
            self.signup.alpha = 1
            self.signup.transform = .identity
            self.login.alpha = 0.5
            self.login.transform = .identity
        } completion: { done in
            
        }
    }
    
    func signupUser() {
        fadeOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = SignupViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }        
    }
    
    func loginUser() {
        fadeOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.9) {
            self.moonImageView.transform = .identity
            self.moonImageView.alpha = 0
        }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.5, options: [], animations: {
            self.bodyLabel.alpha = 0
            self.bodyLabel.transform = CGAffineTransform(translationX: 0, y: -20)
            self.titleLabel.alpha = 0
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        }, completion: nil)
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [], animations: {
            self.backgroundImage.transform = CGAffineTransform(translationX: 0, y: -100)
            self.backgroundImage.alpha = 0
        }, completion: nil)
    }
}


@available(iOS 13.0, *)
struct IntroContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(IntroViewController())
        }
    }
}

