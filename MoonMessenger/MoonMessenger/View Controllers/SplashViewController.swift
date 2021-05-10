//
//  ViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/9/21.
//

import UIKit
import Preview
import SwiftUI
import SnapKit
import Hero


class SplashViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        let backgroundImage = UIImageView(image: UIImage(named: "NightSky") ?? UIImage())
        backgroundImage.hero.id = "background"
        backgroundImage.alpha = 0
        view.addSubview(backgroundImage)
        
        let imageView = UIImageView(image: UIImage(named: "Moon") ?? UIImage())
        imageView.hero.id = "moon"        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.top.equalToSuperview().offset(-200)
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = IntroViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


@available(iOS 13.0, *)
struct SplashContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(SplashViewController())
        }
    }
}

