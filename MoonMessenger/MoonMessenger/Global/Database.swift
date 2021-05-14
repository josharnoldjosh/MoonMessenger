//
//  Database.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/14/21.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftUI


struct User {
    @AppStorage("Username") static var username:String = ""
}


struct Backend {
    
    static let shared = Backend()
    
    var ref: DatabaseReference = Database.database().reference()
    
    func updateUsername() {
        if let user = Auth.auth().currentUser {
            self.ref.child("users").child(user.uid).setValue(["username": User.username])
        }
    }
}
