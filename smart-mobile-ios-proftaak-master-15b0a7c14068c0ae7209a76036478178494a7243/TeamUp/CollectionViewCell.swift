//
//  CollectionViewCell.swift
//  TeamUp
//
//  Created by Fhict on 01/12/16.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelUserName: UILabel?
    @IBOutlet weak var imageViewProfilePicture: UIImageView?
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        UserInterfaceUtility.setRoundProfilePicture(profilePicture: imageViewProfilePicture!)
    }
    
}
