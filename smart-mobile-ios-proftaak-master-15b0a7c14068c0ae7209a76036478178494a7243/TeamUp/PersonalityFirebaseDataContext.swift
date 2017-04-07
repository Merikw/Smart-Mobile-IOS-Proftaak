//
//  PersonalityFirebaseDataContext.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PersonalityFirebaseDataContext : PersonalityDataContract {
    
    // Referenties Firebase opslag
    let databaseRef = FIRDatabase.database().reference()
    let storageRef =  FIRStorage.storage().reference()
    
    func savePersonality(entityId: String, personality: Personality) {
        self.databaseRef.child("personality-types").child(entityId).setValue(personality.characterTraits)
    }
    
    func getPersonality(entityId: String, completion: @escaping (Personality) -> ()) {
        let personality = Personality()
        
        databaseRef.child("personality-types").child(entityId).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshot: NSArray = [snapshot.value!]
            if let characterTraits: NSArray = snapshot.object(at: 0) as? NSArray {
                for characterTrait in characterTraits {
                    personality.addCharacterTrait(characterTrait: characterTrait as! String)
                }
            }
            completion(personality)
        })
    }
    
}
