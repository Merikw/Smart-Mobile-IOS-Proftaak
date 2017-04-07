//
//  ProjectDataRepository.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class ProjectDataRepository {
    
    let context: ProjectDataContract
    
    init(context: ProjectDataContract) {
        self.context = context
    }
    
    func addProject(project: Project) {
        context.addProject(project: project)
    }
    
    func getAllProjects(completion: @escaping ([Project]) -> ()) {
        context.getAllProjects(completion: { (projects) in
            completion(projects)
        })
    }
    
    func removeProject(projectId: String) {
        context.removeProject(projectId: projectId)
    }
    
}
