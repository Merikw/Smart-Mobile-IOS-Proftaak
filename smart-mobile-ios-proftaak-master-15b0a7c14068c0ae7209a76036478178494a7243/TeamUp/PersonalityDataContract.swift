//
//  PersonalityDataContract.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

protocol PersonalityDataContract {
    
    func savePersonality(entityId: String, personality: Personality)
    
    func getPersonality(entityId: String, completion: @escaping (Personality) -> ())
    
}
