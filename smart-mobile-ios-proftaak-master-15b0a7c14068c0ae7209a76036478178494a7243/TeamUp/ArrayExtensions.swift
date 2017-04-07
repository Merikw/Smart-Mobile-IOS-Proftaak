//
//  ArrayExtensions.swift
//  TeamUp
//
//  Created by Fhict on 09/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Extentiemethode voor Arrays waarmee een element dat voldoet aan het protocol Equatable kan worden verwijderd
    mutating func removeObject(object: Element){
        if let index = index(of: object){
            remove(at: index)
        }
    }
    
}
