//
//  EditPersonalityTableViewController.swift
//  TeamUp
//
//  Created by Fhict on 09/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class EditPersonalityTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var entityId = ""
    var user = User()
    var project = Project()
    var selectedCharacterTraits = [String]()
    
    // Data repository
    let personalityDataRepository = PersonalityDataRepository(context: PersonalityFirebaseDataContext())
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Personality"
        
        navigationItem.hidesBackButton = true
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditPersonalityTableViewController.save(sender:)))
        navigationItem.leftBarButtonItem = saveButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Bepaal het id van de gebruiker of het project waarvan de vereiste persoonlijkheid wordt bewerkt
        entityId = (user.id == nil ? project.id : user.id)!
        
        personalityDataRepository.getPersonality(entityId: entityId, completion: { (personality) in
            self.selectedCharacterTraits = personality.characterTraits
            self.updateCharacterTraits()
        })
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCharacterTraits()
    }
    
    func save(sender: UIBarButtonItem) {
        if (entityId == user.id) {
            user.addPersonality(personality: Personality())
            user.personality?.characterTraits = selectedCharacterTraits
            personalityDataRepository.savePersonality(entityId: entityId, personality: user.personality!)
        } else {
            project.addPersonality(personality: Personality())
            project.personality?.characterTraits = selectedCharacterTraits
            personalityDataRepository.savePersonality(entityId: entityId, personality: project.personality!)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func updateCharacterTraits() {
        for cell in self.tableView.visibleCells {
            if (self.selectedCharacterTraits.contains((cell.textLabel?.text!)!)) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                cell.tintColor = UIColor(red: 57/255, green: 170/255, blue: 53/255, alpha: 1)
            }
        }
    }
    
    // MARK: Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if (!selectedCharacterTraits.contains((cell?.textLabel?.text)!)) {
            selectedCharacterTraits.append((cell?.textLabel?.text)!)
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            selectedCharacterTraits.remove(at: selectedCharacterTraits.index(of: (cell?.textLabel?.text)!)!)
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
}
