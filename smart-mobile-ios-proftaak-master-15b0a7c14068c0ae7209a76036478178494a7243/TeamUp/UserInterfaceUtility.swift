//
//  UserInterfaceUtility.swift
//  TeamUp
//
//  Created by Fhict on 02/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit
import Foundation

class UserInterfaceUtility {
    
    // Constanten setRoundProfilePicture
    static let borderWidthImageView: CGFloat = 4.0

    // Constanten setColorTextField
    static let borderWidthTextField: CGFloat = 1.0
    static let cornerRadiusTextField: CGFloat = 5.0
    
    // Maakt een UIImageView rond
    static func setRoundProfilePicture(profilePicture: UIImageView) {
        // Maak de rand van imageViewProfilePicture rond
        profilePicture.layer.cornerRadius = (profilePicture.frame.size.width) / 2.0
        // Verwijder het overlappende deel van de profielfoto
        profilePicture.layer.masksToBounds = true
        // Stel de randbreedte in
        profilePicture.layer.borderWidth = borderWidthImageView
    }
    
    // Tekent een rode rand om de UItextField wanneer true wordt meegegeven als argument en tekent een normale rand wanneer er false wordt meegegeven als argument
    static func setColorTextField(textField: UITextField, errorColor: Bool) {
        textField.layer.borderWidth = borderWidthTextField
        textField.layer.cornerRadius = cornerRadiusTextField
        
        if(errorColor) {
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1).cgColor
        }
    }
    
}
