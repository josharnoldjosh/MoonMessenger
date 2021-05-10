//
//  Style.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/9/21.
//

import UIKit


extension UIColor {
    
    static var background:UIColor {
        return UIColor(red: 0.12, green: 0.13, blue: 0.16, alpha: 1.00)        
    }
    
    static var primary:UIColor {
        return UIColor(red: 0.35, green: 0.12, blue: 1.00, alpha: 1.00)
    }
    
    static var secondary:UIColor {
        return UIColor(red: 1.00, green: 0.15, blue: 0.82, alpha: 1.00)    
    }
    
    static var darkShadow:UIColor {
        return UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    }
}


extension UIFont {
    static var body:UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "Pacifico-Regular", size: 16) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
    
    static var caption:UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "Pacifico-Regular", size: 14) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
    
    static var bodyReadable:UIFont {        
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "HelveticaNeue-Medium", size: 15) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
    }
}


extension UILabel {
    
    
     static func title() -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: "Pacifico-Regular", size: 40) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize))
        label.textColor = .white
        label.text = "Hello world."
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
}
