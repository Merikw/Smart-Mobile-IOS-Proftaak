//
//  EditSkillsetViewController.swift
//  TeamUp
//
//  Created by Fhict on 09/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class EditSkillsetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var textFieldCompetence: UITextField!
    @IBOutlet weak var tableViewSkillset: UITableView!
    
    var entityId = ""
    var user = User()
    var project = Project()
    var selectedTechnicalCompetences = [String]()
    
    // Data repositories
    let skillsetDataRepository = SkillsetDataRepository(context: SkillsetFirebaseDataContext())
    
    // MARK: Actions
    
    @IBAction func didTapAddCompetence(_ sender: UIButton) {
        if (selectedTechnicalCompetences.contains(textFieldCompetence.text!) || (textFieldCompetence.text?.isEmpty)!) {
            UserInterfaceUtility.setColorTextField(textField: textFieldCompetence, errorColor: true)
        } else {
            UserInterfaceUtility.setColorTextField(textField: textFieldCompetence, errorColor: false)
            selectedTechnicalCompetences.append(textFieldCompetence.text!)
            textFieldCompetence.text = ""
            tableViewSkillset.reloadData()
        }
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Skillset"
        
        UserInterfaceUtility.setColorTextField(textField: textFieldCompetence, errorColor: false)
        
        tableViewSkillset.dataSource = self
        tableViewSkillset.delegate = self
        tableViewSkillset.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewSkillset.allowsSelectionDuringEditing = false
        tableViewSkillset.reloadData()
        
        navigationItem.hidesBackButton = true
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditSkillsetViewController.save(sender:)))
        navigationItem.leftBarButtonItem = saveButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserInterfaceUtility.setColorTextField(textField: textFieldCompetence, errorColor: false)
        
        // Bepaal het id van de gebruiker of het project waarvan de vereiste skillset wordt bewerkt
        entityId = (user.id == nil ? project.id : user.id)!
        
        skillsetDataRepository.getSkillset(entityId: entityId, completion: { (skillset) in
            self.selectedTechnicalCompetences = skillset.technicalCompetences
            self.tableViewSkillset.reloadData()
        })
    }
    
    func save(sender: UIBarButtonItem) {
        if (entityId == user.id) {
            user.addSkillset(skillset: Skillset())
            user.skillset?.technicalCompetences = selectedTechnicalCompetences
            skillsetDataRepository.saveSkillset(entityId: entityId, skillset: user.skillset!)
        } else {
            project.addSkillset(skillset: Skillset())
            project.skillset?.technicalCompetences = selectedTechnicalCompetences
            skillsetDataRepository.saveSkillset(entityId: entityId, skillset: project.skillset!)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTechnicalCompetences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsetCell")! as UITableViewCell
        let currentRow = (indexPath as NSIndexPath).row
        cell.textLabel?.text = selectedTechnicalCompetences[currentRow]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Skillset"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let currentRow = (indexPath as NSIndexPath).row
        selectedTechnicalCompetences.remove(at: currentRow)
        tableView.reloadData()
    }
    
}
