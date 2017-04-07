//
//  EditContactInformationViewController.swift
//  TeamUp
//
//  Created by Fhict on 10/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class EditContactInformationViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var textFieldEmailAddress: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    
    var user = User()
    
    // Data repository
    let userDataRepository = UserDataRepository(context: UserFirebaseDataContext())
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contact information"
        textFieldEmailAddress.text = user.email
        textFieldPhoneNumber.text = user.phone
        
        UserInterfaceUtility.setColorTextField(textField: textFieldEmailAddress, errorColor: false)
        UserInterfaceUtility.setColorTextField(textField: textFieldPhoneNumber, errorColor: false)
        
        navigationItem.hidesBackButton = true
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditContactInformationViewController.save(sender:)))
        navigationItem.leftBarButtonItem = saveButton
    }
    
    func save(sender: UIBarButtonItem) {
        let emailAddress = textFieldEmailAddress.text
        let phoneNumber = textFieldPhoneNumber.text
        
        if ((emailAddress?.isEmpty)! || (phoneNumber?.isEmpty)!) {
            return
        }
        
        user.updateEmail(email: emailAddress!)
        user.updatePhone(phone: phoneNumber!)
        userDataRepository.updateUser(user: user)
        
        _ = navigationController?.popViewController(animated: true)
    }

}
