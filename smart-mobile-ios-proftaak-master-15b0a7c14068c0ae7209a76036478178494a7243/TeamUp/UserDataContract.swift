//
//  UserDataContract.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

protocol UserDataContract {
    
    func checkIfUserExists(userId: String, completion: @escaping (Bool) -> ())
        
    func addUser(user: User)
    
    func updateUser(user: User)
    
    func getUser(userId: String, completion: @escaping (User) -> ())
    
    func getAllUsers(completion: @escaping ([User]) -> ())
    
    func removeUser(userId: String)
    
    func checkIfCompanyExists(company: String, completion: @escaping (Bool) -> ())
            
}
