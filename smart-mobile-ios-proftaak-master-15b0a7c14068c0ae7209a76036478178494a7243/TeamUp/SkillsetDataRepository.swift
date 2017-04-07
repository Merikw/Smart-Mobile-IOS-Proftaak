//
//  SkillsetDataRepository.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class SkillsetDataRepository {
    
    let context: SkillsetDataContract
    
    init(context: SkillsetDataContract) {
        self.context = context
    }
    
    func saveSkillset(entityId: String, skillset: Skillset) {
        context.saveSkillset(entityId: entityId, skillset: skillset)
    }
    
    func getSkillset(entityId: String, completion: @escaping (Skillset) -> ()) {
        context.getSkillset(entityId: entityId, completion: { (skillset) in
            completion(skillset)
        })
    }
    
}
