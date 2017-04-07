//
//  UserDataContext.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class UserFirebaseDataContext : UserDataContract {
    
    // Referenties Firebase opslag
    let databaseRef = FIRDatabase.database().reference()
    let storageRef =  FIRStorage.storage().reference()
    
    func checkIfUserExists(userId: String, completion: @escaping (Bool) -> ()) {
        databaseRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.hasChild(userId)) {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func addUser(user: User) {
        let profilePicture = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300, "redirect":false], httpMethod: "GET")
        _ = profilePicture?.start(completionHandler: { (connection, result, error) -> Void in
            let dictionary = result as? NSDictionary
            let json = JSON(dictionary?.object(forKey: "data") as Any)
            if let urlPicture = json["url"].string {
                if let imageData = NSData(contentsOf: NSURL(string: urlPicture)! as URL) {
                    let imageRef = self.storageRef.child("user-images/\(user.id!)/profile_picture.jpg")
                    imageRef.put(imageData as Data, metadata: nil) { metadata,error in
                        self.databaseRef.child("users").child(user.id!).setValue(["name": user.name!, "email": user.email!, "phone": "", "company": user.company!])
                    }
                }
            }
        })
    }
    
    func updateUser(user: User) {
        databaseRef.child("users").child(user.id!).setValue(["name": user.name!, "email": user.email!, "phone": user.phone!, "company": user.company!])
    }
    
    func getUser(userId: String, completion: @escaping (User) -> ()) {
        databaseRef.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let json = JSON(snapshot.value!)
            let name = json["name"].string!
            let email = json["email"].string!
            let phone = json["phone"].string!
            let company  = json["company"].string!
            
            self.storageRef.child("user-images/\((userId))/profile_picture.jpg").downloadURL(completion: { (url, error) in
                completion(User(id: userId, name: name, email: email, phone: phone, profilePicture: NSData(contentsOf: NSURL(string: url!.absoluteString)! as URL)! as Data, company: company))
            })
        })
    }
    
    func getAllUsers(completion: @escaping ([User]) -> ()) {
        var users = [User]()
        
        databaseRef.child("users").observe(.value, with: { (snapshot) in
            users = [User]()
            
            if (snapshot.childrenCount == 0) {
                completion(users)
            }
            
            var userCounter = 0
            
            for user in snapshot.children.allObjects as! [FIRDataSnapshot] {
                userCounter += 1
                
                let json = JSON(user.value!)
                let name = json["name"].string!
                let email = json["email"].string!
                let phone = json["phone"].string!
                let company  = json["company"].string!
                
                _ = self.storageRef.child("user-images/\((user.key))/profile_picture.jpg").downloadURL(completion: { (url, error) in
                    users.append(User(id: user.key, name: name, email: email, phone: phone, profilePicture: NSData(contentsOf: NSURL(string: url!.absoluteString)! as URL)! as Data, company: company))
                    
                    if userCounter == Int(snapshot.childrenCount) {
                        completion(users)
                    }
                })
            }
        })
    }
    
    func removeUser(userId: String) {
        databaseRef.child("users").child(userId).removeValue()
        databaseRef.child("skillsets").child(userId).removeValue()
        databaseRef.child("personality-types").child(userId).removeValue()
    }
    
    func checkIfCompanyExists(company: String, completion: @escaping (Bool) -> ()) {
        databaseRef.child("companies").observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.hasChild(company)) {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
}
