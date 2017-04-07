//
//  Project.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class Project {
    
    let id: String?
    let name: String?
    var skillset: Skillset?
    var personality: Personality?
    
    init() {
        id = nil
        name = nil
        skillset = Skillset()
        personality = Personality()
    }
    
    init(name: String) {
        id = nil
        self.name = name
        skillset = Skillset()
        personality = Personality()
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        skillset = Skillset()
        personality = Personality()
    }
    
    func addSkillset(skillset: Skillset) {
        self.skillset = skillset
    }
    
    func addPersonality(personality: Personality) {
        self.personality = personality
    }
    
}
