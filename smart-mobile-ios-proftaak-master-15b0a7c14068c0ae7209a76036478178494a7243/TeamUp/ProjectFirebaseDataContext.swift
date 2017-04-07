//
//  ProjectFirebaseDataContext.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProjectFirebaseDataContext : ProjectDataContract {
    
    // Referenties Firebase opslag
    let databaseRef = FIRDatabase.database().reference()
    let storageRef =  FIRStorage.storage().reference()
    
    func addProject(project: Project) {
        self.databaseRef.child("projects").childByAutoId().setValue(["name": project.name!])
    }
    
    func getAllProjects(completion: @escaping ([Project]) -> ()) {
        var projects = [Project]()
        
        databaseRef.child("projects").observe(.value, with: { (snapshot) in
            projects = [Project]()
            
            if (snapshot.childrenCount == 0) {
                completion(projects)
            }

            for project in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let json = JSON(project.value!)
                let name = json["name"].string!
                
                projects.append(Project(id: project.key, name: name))
                completion(projects)
            }
        })
    }
    
    func removeProject(projectId: String) {
        databaseRef.child("projects").child(projectId).removeValue()
    }
    
}
