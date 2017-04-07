//
//  SkillsetDataContract.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

protocol SkillsetDataContract {
    
    func saveSkillset(entityId: String, skillset: Skillset)
    
    func getSkillset(entityId: String, completion: @escaping (Skillset) -> ())
    
}
