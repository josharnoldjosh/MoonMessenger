//
//  WelcomeViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/10/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import Closures


class WelcomeViewController : UIViewController {
    
    var daeView:ExploreObjectView = ExploreObjectView(zoom: 9)
    var titleLabel:UILabel = UILabel.title()
    var bodyLabel:UILabel = UILabel.body()
    var continueButton:ShinyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        snap()
    }
    
    func setupUI() {
        daeView.alpha = 0
        view.addSubview(daeView)
        
        titleLabel.text = "Moon."
        titleLabel.alpha = 0
        view.addSubview(titleLabel)
        
        bodyLabel.text = "Beautiful, secure, messaging."
        bodyLabel.alpha = 0
        view.addSubview(bodyLabel)
                
        continueButton = ShinyButton("Start Messaging") {
            self.goToHome()
        }
        continueButton.alpha = 0
        view.addSubview(continueButton)
    }
    
    func snap() {
        daeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-80)
            make.width.equalTo(180)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.titleLabel.alpha = 1
            self.bodyLabel.alpha = 0.5
            self.daeView.alpha = 1
            self.continueButton.alpha = 1
        }
    }
    
    func goToHome() {
        print("Yessir!")
    }
}

@available(iOS 13.0, *)
struct WelcomeContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(WelcomeViewController())
        }
    }
}

