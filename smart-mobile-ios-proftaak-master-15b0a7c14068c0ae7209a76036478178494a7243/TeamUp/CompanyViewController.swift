//
//  CompanyViewController.swift
//  TeamUp
//
//  Created by Fhict on 01/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit
import FirebaseAuth

class CompanyViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var textFieldCompanyCode: UITextField!
    
    // Data repository
    let userDataRepository = UserDataRepository(context: UserFirebaseDataContext())
    
    var user = User()
    
    // MARK: Actions
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        var company = textFieldCompanyCode.text!
        company = company.isEmpty ? " " : company

        userDataRepository.checkIfCompanyExists(company: company, completion: { (companyExists) in
            if (companyExists) {
                self.user.addCompany(company: company)
                self.userDataRepository.addUser(user: self.user)
                
                // Navigeer naar de Projects view
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let projectsViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                self.present(projectsViewController, animated: false , completion: nil)
            } else {
                UserInterfaceUtility.setColorTextField(textField: self.textFieldCompanyCode, errorColor: true)
            }
        })
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserInterfaceUtility.setColorTextField(textField: textFieldCompanyCode, errorColor: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserInterfaceUtility.setColorTextField(textField: textFieldCompanyCode, errorColor: false)
    }
    
}
