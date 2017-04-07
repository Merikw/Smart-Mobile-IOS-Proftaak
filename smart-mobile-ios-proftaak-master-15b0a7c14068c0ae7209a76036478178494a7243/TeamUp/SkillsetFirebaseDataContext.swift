//
//  SkillsetFirebaseDataContext.swift
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

class SkillsetFirebaseDataContext : SkillsetDataContract {
    
    // Referenties Firebase opslag
    let databaseRef = FIRDatabase.database().reference()
    let storageRef =  FIRStorage.storage().reference()
    
    func saveSkillset(entityId: String, skillset: Skillset) {
        self.databaseRef.child("skillsets").child(entityId).setValue(skillset.technicalCompetences)
    }
    
    func getSkillset(entityId: String, completion: @escaping (Skillset) -> ()) {
        let skillset = Skillset()
        
        databaseRef.child("skillsets").child(entityId).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshot: NSArray = [snapshot.value!]
            if let techincalCompetences: NSArray = snapshot.object(at: 0) as? NSArray {
                for technicalCompetence in techincalCompetences {
                    skillset.addTechnicalCompetence(technicalCompetence: technicalCompetence as! String)
                }
            }
            completion(skillset)
        })
    }
    
}
