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
    
    func observeUsername() {
        guard let user = Auth.auth().currentUser else {return}
        let _ = self.ref.child("users/\(user.uid)/username").observe(DataEventType.value, with: { (snapshot) in
            User.username = snapshot.value as? String ?? "Username"
        })
    }
    
    func getUsername(completion: @escaping (_ username:String) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        self.ref.child("users/\(user.uid)/username").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
                completion(User.username)
            }
            else if snapshot.exists() {
                let res = snapshot.value as? String ?? "Username"
                User.username = res
                completion(res)
            }
        }
    }
}
