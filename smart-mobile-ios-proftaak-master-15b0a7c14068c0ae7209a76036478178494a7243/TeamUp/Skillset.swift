//
//  Skillset.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

class Skillset {
    
    var technicalCompetences: [String]
    
    init() {
        technicalCompetences = [String]()
    }
    
    func addTechnicalCompetence(technicalCompetence: String) {
        technicalCompetences.append(technicalCompetence)
    }
    
}
