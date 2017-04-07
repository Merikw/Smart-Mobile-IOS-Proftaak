//
//  EnrollmentDataContract.swift
//  TeamUp
//
//  Created by Fhict on 15/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

protocol EnrollmentDataContract {
    
    func enrollInProject(projectId: String, userId: String)
    
    func withdrawFromProject(projectId: String, userId: String)
    
    func getCurrentEnrollment(projectId: String, completion: @escaping ([String]) -> ());
    
}
