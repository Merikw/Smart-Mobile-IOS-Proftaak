//
//  User.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class User: Equatable {

    let id: String?
    let name: String?
    var email: String?
    var phone: String?
    let profilePicture: Data?
    var company: String?
    var skillset: Skillset?
    var personality: Personality?

    init() {
        id = nil
        name = nil
        email = nil
        phone = nil
        profilePicture = nil
        company = nil
        skillset = Skillset()
        personality = Personality()
    }

    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        phone = nil
        profilePicture = nil
        company = nil
        skillset = Skillset()
        personality = Personality()
    }
    
    init(id: String, name: String, email: String, phone: String, profilePicture: Data, company: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.profilePicture = profilePicture
        self.company = company
        skillset = Skillset()
        personality = Personality()
    }
    
    func addCompany(company: String) {
        self.company = company
    }
    
    func updateEmail(email: String) {
        self.email = email
    }
    
    func updatePhone(phone: String) {
        self.phone = phone
    }
    
    func addSkillset(skillset: Skillset) {
        self.skillset = skillset
    }
    
    func addPersonality(personality: Personality) {
        self.personality = personality
    }
    
    // Methode die moet worden geïmplementeerd om te voldoen aan het Equatable protocol
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
}
