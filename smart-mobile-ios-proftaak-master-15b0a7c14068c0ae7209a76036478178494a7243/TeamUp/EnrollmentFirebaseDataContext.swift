//
//  EnrollmentFirebaseDataContext.swift
//  TeamUp
//
//  Created by Fhict on 15/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EnrollmentFirebaseDataContext : EnrollmentDataContract {
    
    // Referenties Firebase opslag
    let databaseRef = FIRDatabase.database().reference()
    let storageRef =  FIRStorage.storage().reference()
    
    func enrollInProject(projectId: String, userId: String) {
        getCurrentEnrollment(projectId: projectId, completion: { (currentEnrollments) in
            var enrollments = currentEnrollments
            enrollments.append(userId)
            self.databaseRef.child("enrollments").child(projectId).setValue(enrollments)
        })
    }
    
    func withdrawFromProject(projectId: String, userId: String) {
        getCurrentEnrollment(projectId: projectId, completion: { (currentEnrollments) in
            var enrollments = currentEnrollments
            enrollments.removeObject(object: userId)
            self.databaseRef.child("enrollments").child(projectId).setValue(enrollments)
        })
    }
    
    func getCurrentEnrollment(projectId: String, completion: @escaping ([String]) -> ()) {
        var enrollments = [String]()
        
        databaseRef.child("enrollments").child(projectId).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshot: NSArray = [snapshot.value!]
            if let currentEnrollments: NSArray = snapshot.object(at: 0) as? NSArray {
                for enrollment in currentEnrollments {
                    enrollments.append(enrollment as! String)
                }
            }
            completion(enrollments)
        })
    }
    
}
