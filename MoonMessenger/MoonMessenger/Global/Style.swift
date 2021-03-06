//
//  Style.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/9/21.
//

import UIKit
import SwiftUI
import Combine


extension UIColor {
    
    static var background:UIColor {
        return UIColor(red: 0.12, green: 0.13, blue: 0.16, alpha: 1.00)        
    }
    
    static var primary:UIColor {
        return UIColor(red: 0.56, green: 0.00, blue: 0.91, alpha: 1.00)
    }
    
    static var secondary:UIColor {
        return UIColor(red: 0.36, green: 0.13, blue: 1.00, alpha: 1.00)
    }
    
    static var darkShadow:UIColor {
        return UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    }
    
    static var lightShadow:UIColor {
        return UIColor(red: 0.24, green: 0.27, blue: 0.33, alpha: 1.00)
    }
}


extension UIFont {
    
    static var large:UIFont {
        return UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: "AvenirNext-Medium", size: 30) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
    
    static var body:UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "AvenirNext-Medium", size: 16) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
    
    static var caption:UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "AvenirNext-Medium", size: 14) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
    
    static var mini:UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "AvenirNext-Medium", size: 11) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
}


extension UILabel {
    
    
    static func title(text: String="Hello") -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: "AvenirNext-Regular", size: 40) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        label.textColor = .white
        label.attributedText = NSAttributedString(string: text, attributes: [.kern : 10])
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }
    
    static func body() -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .body
        label.textColor = .white
        label.text = "This is a body label! Cool, huh?"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0.5
        return label
    }
}


struct Impact {
    static func button() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    static func hint() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}


// MARK: UIApplication extensions

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


extension UIImage {
    static func download(from url:URL, completion: @escaping (_ image:UIImage) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }            
            completion(image)
        }.resume()
    }
}
