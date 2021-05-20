//
//  JoinChannelViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/14/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import Closures
import PopBounceButton
import JGProgressHUD


class JoinChannelViewController : UIViewController {
    
    var back:BackButton!
    var topLogo:UIImageView = UIImageView(image: UIImage(named: "NewUser") ?? UIImage())
    var textfield:TextField!
    var instructions:UILabel = UILabel.body()
    var refresh:ImageButton!
    var copy:ImageButton!
    var continueButton:ShinyButton!
    
    
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
            self.pop()
        })
        view.addSubview(back)
        
        topLogo.contentMode = .scaleAspectFit
        view.addSubview(topLogo)
        
        textfield = TextField(imageName: "LockIcon", placeholder: "Private Key")
        textfield.key()
        textfield.textfield.font = .mini
        view.addSubview(textfield)
        
        instructions.text = "Enter an existing private key to join a channel, or tap the refresh button to generate a new key."
        instructions.alpha = 0.4
        view.addSubview(instructions)
        
        refresh = ImageButton(imageNames: ["RefreshA", "RefreshB"], onTap: {
            let uuid = UUID().uuidString
            self.textfield.textfield.text = uuid
        })
        view.addSubview(refresh)
        
        copy = ImageButton(imageNames: ["CopyA", "CopyB"], onTap: {
            UIPasteboard.general.string = self.textfield.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.showCopied()
        })
        view.addSubview(copy)
        
        continueButton = ShinyButton("Continue", onTap: {
            
            let result = self.textfield.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            guard result.count >= UUID().uuidString.count else { return }
            
            let hud = JGProgressHUD()
            hud.style = .dark
            hud.show(in: self.view)
            
            Backend.shared.createConvo(key: result, completion: { error in
                    hud.dismiss()
                    if error == nil {
                        self.pop()
                    }else{
                        self.showError()
                    }
            })
        })
        view.addSubview(continueButton)
    }
    
    func showError() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Error!"
        hud.textLabel.font = .body
        hud.isUserInteractionEnabled = true
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        self.view.isUserInteractionEnabled = true
        hud.dismiss(afterDelay: 0.5, animated: true)
    }
    
    func showCopied() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Copied!"
        hud.textLabel.font = .body
        hud.isUserInteractionEnabled = true
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)
        self.view.isUserInteractionEnabled = true
        hud.dismiss(afterDelay: 0.5, animated: true)
    }
    
    func pop() {
        self.hero.modalAnimationType = .slide(direction: .right)
        self.hero.dismissViewController()
    }
    
    func snap() {
        back.snp.makeConstraints { make in
            make.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.width.equalTo(40)
        }
        
        topLogo.snp.makeConstraints { make in
            make.centerY.height.equalTo(self.back)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
        }
        
        textfield.snp.makeConstraints { make in
            make.top.equalTo(self.topLogo.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        instructions.snp.makeConstraints { make in
            make.top.equalTo(self.textfield.snp.bottom).offset(40)
            make.width.equalTo(250)
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        
        refresh.snp.makeConstraints { make in
            make.top.equalTo(self.instructions.snp.bottom).offset(0)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview().offset(-60)
        }
        
        copy.snp.makeConstraints { make in
            make.top.equalTo(self.instructions.snp.bottom).offset(0)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview().offset(60)
        }
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}

@available(iOS 13.0, *)
struct JoinChannelContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(JoinChannelViewController())
        }
    }
}

