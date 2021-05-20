//
//  Message.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/3/21.
//

import UIKit


//enum CurveStyle {
//    case basic
//    case top
//    case middle
//    case bottom
//}


enum Origin {
    case outgoing
    case incoming
    case system
}


enum Rounding {
    case basic
    case top
    case middle
    case bottom
}


protocol Sendable {
    var origin:Origin { get }
}


struct DateStamp : Hashable, Sendable {
    var origin: Origin
}


struct Message : Hashable, Equatable, Sendable, Changeable {
    
    var origin:Origin
    var text:String
    var id:UUID
    var date:Date = Date()
    var corners:Rounding = .basic
    
    /// Whether or not the message was delivered
    var delivered:Bool = false
    
    /// Whether or not the reciever has "seen" the  message
    var seen:Bool = false
        
    /// Whether or not there was an error sending the message
    var error:Bool = false
    
    var username:String = "User"
        
    init(id: UUID, text:String, origin:Origin = .outgoing, date:Date = Date(), delivered:Bool = false, seen:Bool = false, error:Bool = false, username:String = "User") {
        self.text = text
        self.id = UUID()
        self.origin = origin
        self.date = date
        self.delivered = delivered
        self.seen = (origin == .outgoing ? false : true) || seen
        self.error = false
        self.username = username
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.seen)
    }
    
    mutating func markDelivered() {
        delivered = true
    }
    
    mutating func markSeen() {
        guard delivered == true else {
            print("A message cannot be 'seen' if it hasn't been delivered yet.")
            return
        }
        self.seen = true
    }
    
    mutating func markError() {
        guard delivered == false else {
            print("An error cannot occur if the message has been delivered.")
            return
        }
        self.error = true
    }
}


struct Section : Hashable {
    
    var id:UUID
    var origin:Origin
    
    init(origin:Origin = .outgoing) {
        self.origin = origin
        self.id = UUID()
    }
}


protocol Changeable {}
extension Changeable {
    func changing(change: (inout Self) -> Void) -> Self {
        var a = self
        change(&a)
        return a
    }
}
