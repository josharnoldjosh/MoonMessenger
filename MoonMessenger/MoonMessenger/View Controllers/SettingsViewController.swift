//
//  SettingsViewController.swift
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


class SettingsViewController : UIViewController {
    
    var back:BackButton!
    var topLogo:UIImageView = UIImageView(image: UIImage(named: "SettingsIcon") ?? UIImage())
    var instructions:UILabel = UILabel.body()
    private var settingsMoon:UIImageView = UIImageView(image: UIImage(named: "SettingsMoon") ?? UIImage())
    private var crane:UIImageView = UIImageView(image: UIImage(named: "Crane") ?? UIImage())
    
    
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
        
        settingsMoon.contentMode = .scaleAspectFill
        view.addSubview(settingsMoon)
        
        crane.contentMode = .scaleAspectFit
        view.addSubview(crane)
        
        back = BackButton(tap: {
            self.hero.modalAnimationType = .slide(direction: .right)
            self.hero.dismissViewController()
        })
        view.addSubview(back)
        
        topLogo.contentMode = .scaleAspectFit
        view.addSubview(topLogo)
        
        instructions.text = "Neptune is in early alpha. We’re working hard to bring you customizable settings. For now, please check back later!"
        instructions.alpha = 0.4
        view.addSubview(instructions)
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
                
        instructions.snp.makeConstraints { make in
            make.top.equalTo(self.back.snp.bottom).offset(40)
            make.width.equalTo(250)
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        
        settingsMoon.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(350)
        }
        
        crane.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(275)
        }
    }
}

@available(iOS 13.0, *)
struct SettingsViewContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(SettingsViewController())
        }
    }
}
