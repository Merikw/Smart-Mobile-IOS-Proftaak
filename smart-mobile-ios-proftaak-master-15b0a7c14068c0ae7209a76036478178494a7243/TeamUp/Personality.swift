//
//  Personality.swift
//  TeamUp
//
//  Created by Fhict on 09/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit
import Foundation

class Personality {
    
    var characterTraits: [String]
    
    init() {
        characterTraits = [String]()
    }
    
    func addCharacterTrait(characterTrait: String) {
        characterTraits.append(characterTrait)
    }
    
    func determineDiscPersonalityStyle() -> PersonalityStyle {
        let resultaat = ["Stelt wat-vragen", "Doelgericht", "Zelfbewust", "Kort van stof", "Bepalend", "Ongeduldig", "Wil controle"]
        let waardering = ["Stelt wie-vragen", "Emotioneel", "Levendig", "Praatgraag", "Optimistisch", "Wispelturig", "Wil enthousiasme"]
        let perfectie = ["Stelt waarom-vragen", "Afstandelijk", "Zorgvuldig", "Gedisciplineerd", "Emotieloos", "Wil redenen"]
        let stabiliteit = ["Stelt hoe-vragen", "Rustig", "Geduldig", "Vriendelijk", "Cooperatief", "Gevoelig", "Wil contact"]
        
        var countDominant = 0
        var countInvloed = 0
        var countConsciëntieus = 0
        var countStabiel = 0
        
        for characterTrait in characterTraits {
            if resultaat.contains(characterTrait) {
                countDominant += 1
            } else if waardering.contains(characterTrait) {
                countInvloed += 1
            } else if perfectie.contains(characterTrait) {
                countConsciëntieus += 1
            } else if stabiliteit.contains(characterTrait) {
                countStabiel += 1
            }
        }
        
        var color = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        var personalityType = PersonalityType.none
        
        if (countDominant + countInvloed + countConsciëntieus + countStabiel == 0) {
            color = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
            personalityType = .none
        } else if (countDominant >= countInvloed && countDominant >= countConsciëntieus && countDominant >= countStabiel) {
            // Rood
            color = UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1)
            personalityType = .dominant
        } else if (countInvloed >= countDominant && countInvloed >= countConsciëntieus && countInvloed >= countStabiel) {
            // Geel
            color = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
            personalityType = .invloed
        } else if (countConsciëntieus >= countDominant && countConsciëntieus >= countInvloed && countConsciëntieus >= countStabiel) {
            // Blauw
            color = UIColor(red: 0/255, green: 0/255, blue: 204/255, alpha: 1)
            personalityType = .consciëntieus
        } else if (countStabiel >= countDominant && countStabiel >= countInvloed && countStabiel >= countConsciëntieus) {
            // Groen
            color = UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1)
            personalityType = .stabiel
        }
        
        return PersonalityStyle(color: color, personalityType: personalityType)
    }
    
}

struct PersonalityStyle {
    
    let color: UIColor
    let personalityType: PersonalityType
    
}

enum PersonalityType {
    
    case none
    case dominant
    case invloed
    case consciëntieus
    case stabiel
    
}
