//
//  Appearance.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/4/21.
//

import UIKit


struct ChatGradient {
    var colors:[UIColor] = []
}


struct ChatLabel {
    var textColor:UIColor
    var font:UIFont
}


struct ChatUserStyle {
    var gradient:ChatGradient
    var label:ChatLabel
}


struct LayoutStyle {
    var sameMessageSpacing:CGFloat = 2.0
    var uniqueMessageSpacing:CGFloat = 16.0
}


struct DateStampStyle {
    var font:UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var color:UIColor = .systemGray2
}

struct UsernameStyle {
    var font:UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var color:UIColor = .systemGray2
}


struct AvatarStyle {
    var showIncomingAvatar:Bool = true
    var avatorImage:UIImage = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    var tintColor:UIColor = UIColor.systemGray5
    var scale:CGFloat = 30
}


struct TypingStyle {
    var dotColor:UIColor = .white
    var backgroundColor:UIColor = .systemGray6
}


struct SeenStyle {
    var enableSeen:Bool = true
    var scale:CGFloat = 20
    var avatorImage:UIImage = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    var tintColor:UIColor = UIColor.systemGray5
}


struct BubbleBounceStyle {
    var enableBouncing:Bool = false
}


struct ChatStyle {
    
    var outgoing:ChatUserStyle = ChatUserStyle(gradient: ChatGradient(colors: [.systemTeal, .systemBlue]), label: ChatLabel(textColor: .white, font: UIFont.preferredFont(forTextStyle: .body)))
    var incoming:ChatUserStyle = ChatUserStyle(gradient: ChatGradient(colors: [.systemGray6]), label: ChatLabel(textColor: .label, font: UIFont.preferredFont(forTextStyle: .body)))
    
    var layout:LayoutStyle              = LayoutStyle()
    var dateStamp:DateStampStyle        = DateStampStyle()
    var username:UsernameStyle          = UsernameStyle()
    var avatar:AvatarStyle              = AvatarStyle()
    var typingIndicator:TypingStyle     = TypingStyle()
    var seen:SeenStyle                  = SeenStyle()
    var bounce:BubbleBounceStyle        = BubbleBounceStyle()
    
    /**
     * Update''s the avatar style.
     */
    mutating func updateAvatarStyle(avatarStyle:AvatarStyle) {
        self.avatar = avatarStyle
    }
}
