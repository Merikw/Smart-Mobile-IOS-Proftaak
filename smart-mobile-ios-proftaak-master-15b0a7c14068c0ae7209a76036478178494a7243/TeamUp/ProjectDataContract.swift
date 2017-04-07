//
//  ProjectDataContract.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

protocol ProjectDataContract {
    
    func addProject(project: Project)
    
    func getAllProjects(completion: @escaping ([Project]) -> ())
    
    func removeProject(projectId: String)

}
