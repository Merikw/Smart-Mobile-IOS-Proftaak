//
//  PersonalityDataRepository.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class PersonalityDataRepository {
    
    let context: PersonalityDataContract
    
    init(context: PersonalityDataContract) {
        self.context = context
    }

    func savePersonality(entityId: String, personality: Personality) {
        context.savePersonality(entityId: entityId, personality: personality)
    }
    
    func getPersonality(entityId: String, completion: @escaping (Personality) -> ()) {
        context.getPersonality(entityId: entityId, completion: { (personality) in
            completion(personality)
        })
    }
    
}
