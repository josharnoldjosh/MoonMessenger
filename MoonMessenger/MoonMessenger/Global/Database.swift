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
                    "date": Date().timeIntervalSince1970,
                    "messageId": UUID().uuidString
                ])
        }
    }
        
    func getMessages(id:String, completion: @escaping (_ messages:[Message]) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let _ = self.ref.child("conversations/\(id)").observe(DataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                let res = data.map({ i in
                    i.value
                }).map({ j -> Message in
                    if let j = j as? [String:Any] {
                        return Message(
                            id: UUID(uuidString: j["messageId"] as? String ?? UUID().uuidString) ?? UUID(),
                            text: j["text"] as? String ?? "<ERROR>",
                            origin: j["user"] as? String ?? "" == user.uid ? .outgoing : .incoming,
                            date: Date(timeIntervalSince1970: j["date"] as? TimeInterval ?? 0),
                            delivered: true,
                            seen: true,
                            error: false,
                            username: j["username"] as? String ?? "User")
                    }
                    return Message(id: UUID(), text: "<ERROR>")
                })
                .sorted { i, j in
                    i.date < j.date
                }
                completion(res)
            }
        })
    }
        
    func getConvoName(id: String, completion: @escaping (_ name:String) -> ()) {
        let _ = self.ref.child("convoData/\(id)/name").observe(.value, with: { (snapshot) in
            if let res = snapshot.value as? String {
                completion(res)
            }else{
                let newName:String = .random()
                self.ref.child("convoData/\(id)/name").setValue(newName)
                completion(newName)
            }
        })
    }
    
    func setConvoName(id: String, name: String) {
        self.ref.child("convoData/\(id)/name").setValue(name)
    }
    
    func getConvoMessage(id: String, completion: @escaping (_ message:String, _ date:Date, _ dateStr:String) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let _ = self.ref.child("conversations/\(id)").observe(DataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                let res = data.map({ i in
                    i.value
                }).map({ j -> Message in
                    if let j = j as? [String:Any] {
                        return Message(
                            id: UUID(uuidString: j["messageId"] as? String ?? UUID().uuidString) ?? UUID(),
                            text: j["text"] as? String ?? "<ERROR>",
                            origin: j["user"] as? String ?? "" == user.uid ? .outgoing : .incoming,
                            date: Date(timeIntervalSince1970: j["date"] as? TimeInterval ?? 0),
                            delivered: true,
                            seen: true,
                            error: false,
                            username: j["user"] as? String ?? "" == user.uid ? "You" : j["username"] as? String ?? "User"
                            )
                    }
                    return Message(id: UUID(), text: "<ERROR>")
                })
                .sorted { i, j in
                    i.date < j.date
                }
                .last
                completion(
                    "\(res?.username ?? "User"): \(res?.text ?? "Message")",
                    res?.date ?? Date(),
                    res?.date.relativeTime ?? "0m"
                )
            }else{
                completion("No messages yet.", Date(), "")
            }
        })
    }
}


extension String {
    static func random() -> String {
        let a = ["Cool", "Interesting", "Informed", "Spicy", "Juicy", "Moist", "Funny", "Goofy", "Angry", "Filthy", "Sinister", "Hairless"]
        let b = ["Cow", "Hippo", "Lion", "Tiger", "Anteater", "Alpaca", "Baboon", "Bear", "Bullfrog", "Bumblebee", "Desert Tortoise"]
        return "\(a.randomElement() ?? "New") \(b.randomElement() ?? "Conversation")"
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
