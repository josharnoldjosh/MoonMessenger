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
            self.ref.child("users").child(user.uid).child("username").setValue(User.username)
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
    
    func createConvo(key:String, completion: @escaping (_ error:Error?) -> ()) {
        guard key != "" else {return}
        if let user = Auth.auth().currentUser {
            Backend.shared.getConvoKeys { keys in
                var res = keys
                res.append(key)
                self.ref
                    .child("users")
                    .child(user.uid)
                    .child("conversations")
                    .setValue(res)
                    { error, ref in
                    completion(error)
                    if error == nil {
                        print("Created new convo with key \(key)!")
                    }
                }
            }
        }
    }
    
    func getConvoKeys(completion: @escaping (_ data: [String]) -> ()) {
        guard Auth.auth().currentUser != nil else { return }
        let user = Auth.auth().currentUser!
        self.ref.child("users").child(user.uid).child("conversations").getData { error, snapshot in
            if snapshot.exists() {
                if let data = (snapshot.value as? [String:Any]) {
                    if let result = (data["conversations"] as? NSMutableArray)?.compactMap({ $0 as? String }) {
                        completion(result.uniqued())
                    }else{
                        completion([])
                    }
               }
            }
        }
    }
    
    func observeUser(update: @escaping () -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let _ = self.ref.child("users/\(user.uid)").observe(DataEventType.value, with: { (snapshot) in
            update()
        })
    }
    
    func sendMessage(text: String, id:String) {
        if let user = Auth.auth().currentUser {
            self.ref
                .child("conversations")
                .child(id)
                .childByAutoId()
                .setValue([
                    "id": id,
                    "text": text,
                    "user": user.uid,
                    "username": User.username,
                    "date": Date().timeIntervalSince1970
                ])
        }
    }
    
    //TODO: Finish this function & connect it to MessagesViewController
    func getMessages(id:String) {
        let _ = self.ref.child("conversations/\(id)").observe(DataEventType.value, with: { (snapshot) in
            print(snapshot.value)
        })
    }
}



extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
