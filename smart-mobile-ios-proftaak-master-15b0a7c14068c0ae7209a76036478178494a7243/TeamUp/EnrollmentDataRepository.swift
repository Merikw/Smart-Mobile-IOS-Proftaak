//
//  EnrollmentDataRepository.swift
//  TeamUp
//
//  Created by Fhict on 15/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class EnrollmentDataRepository {
    
    let context: EnrollmentDataContract
    
    init(context: EnrollmentDataContract) {
        self.context = context
    }
    
    func enrollInProject(projectId: String, userId: String) {
        context.enrollInProject(projectId: projectId, userId: userId)
    }
    
    func withdrawFromProject(projectId: String, userId: String) {
        context.withdrawFromProject(projectId: projectId, userId: userId)
    }
    
    func getCurrentEnrollment(projectId: String, completion: @escaping ([String]) -> ()) {
        context.getCurrentEnrollment(projectId: projectId, completion: { (currentEnrollment) in
            completion(currentEnrollment)
        })
    }
    
}
