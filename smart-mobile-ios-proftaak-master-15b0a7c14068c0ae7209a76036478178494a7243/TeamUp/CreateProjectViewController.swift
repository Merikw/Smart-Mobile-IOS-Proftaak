//
//  CreateProjectViewController.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class CreateProjectViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var textFieldName: UITextField!
    
    //Data repository
    let projectDataRepository = ProjectDataRepository(context: ProjectFirebaseDataContext())
    
    // MARK: Actions
    
    @IBAction func didTapCreateButton(_ sender: UIBarButtonItem) {
        let name = textFieldName.text
        
        if ((name?.isEmpty)!) {
            UserInterfaceUtility.setColorTextField(textField: textFieldName, errorColor: true)
            return
        }
        
        projectDataRepository.addProject(project: Project(name: name!))
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New project"
        
        UserInterfaceUtility.setColorTextField(textField: textFieldName, errorColor: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserInterfaceUtility.setColorTextField(textField: textFieldName, errorColor: false)
    }
    
}
