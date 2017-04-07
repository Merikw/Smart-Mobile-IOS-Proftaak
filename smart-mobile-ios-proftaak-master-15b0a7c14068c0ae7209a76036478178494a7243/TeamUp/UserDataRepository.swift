//
//  UserDataRepository.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class UserDataRepository {
    
    let context: UserDataContract
    
    init(context: UserDataContract) {
        self.context = context
    }
    
    func checkIfUserExists(userId: String, completion: @escaping (Bool) -> ()) {
        context.checkIfUserExists(userId: userId, completion: { (userExists) in
            completion(userExists)
        })
    }
    
    func addUser(user: User) {
        context.addUser(user: user)
    }
    
    func updateUser(user: User) {
        context.updateUser(user: user)
    }
    
    func getUser(userId: String, completion: @escaping (User) -> ()) {
        context.getUser(userId: userId, completion: { (user) in
            completion(user)
        })
    }
    
    func getAllUsers(completion: @escaping ([User]) -> ()) {
        context.getAllUsers(completion: { (users) in
            completion(users)
        })
    }
    
    func removeUser(userId: String) {
        context.removeUser(userId: userId)
    }
    
    func checkIfCompanyExists(company: String, completion: @escaping (Bool) -> ()) {
        context.checkIfCompanyExists(company: company, completion: { (companyExists) in
            completion(companyExists)
        })
    }
    
}
