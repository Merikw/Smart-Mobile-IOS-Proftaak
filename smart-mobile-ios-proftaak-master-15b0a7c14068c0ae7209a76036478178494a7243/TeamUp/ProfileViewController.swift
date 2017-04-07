//
//  ProfileViewController.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var tableViewSkillset: UITableView!
    @IBOutlet weak var tableViewPersonality: UITableView!
    @IBOutlet weak var buttonInfoDiscModel: UIButton!
    
    var user = User()
    
    // Data repositories
    let userDataRepository = UserDataRepository(context: UserFirebaseDataContext())
    let skillsetDataRepository = SkillsetDataRepository(context: SkillsetFirebaseDataContext())
    let personalityDataRepository = PersonalityDataRepository(context: PersonalityFirebaseDataContext())
    
    // MARK: Events
    
    @IBAction func didTapButtonEdit(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Edit profile", message: "What do you want to edit?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let contact = UIAlertAction(title: "Contact information", style: .default) { (action) in
            self.performSegue(withIdentifier: "ToEditContactInformationViewController", sender: self)
        }
        let skillset = UIAlertAction(title: "Skillset", style: .default) { (action) in
            self.performSegue(withIdentifier: "ToEditSkillsetViewController", sender: self)
        }
        let personality = UIAlertAction(title: "Personality", style: .default) { (action) in
            self.performSegue(withIdentifier: "ToEditPersonalityTableViewController", sender: self)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        actionSheet.addAction(contact)
        actionSheet.addAction(skillset)
        actionSheet.addAction(personality)
        actionSheet.addAction(cancel)
                
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didTapButtonLogOut(_ sender: UIBarButtonItem) {
        // Verwijder de gebruikersgegevens
        userDataRepository.removeUser(userId: (FIRAuth.auth()?.currentUser?.uid)!)
        // Log huidige gebruiker uit op Firebase
        try! FIRAuth.auth()!.signOut()
        // Log huidige gebruiker uit op Facebook
        FBSDKAccessToken.setCurrent(nil)
        
        // Navigeer naar de Login view
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(loginViewController, animated: true, completion: nil)
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelEmail.text = ""
        self.labelPhone.text = ""
        
        tableViewSkillset.dataSource = self
        tableViewSkillset.delegate = self
        tableViewSkillset.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewSkillset.allowsSelectionDuringEditing = false
        
        tableViewPersonality.dataSource = self
        tableViewPersonality.delegate = self
        tableViewPersonality.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewPersonality.allowsSelectionDuringEditing = false
        
        activityIndicatorLoading.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userId = (FIRAuth.auth()?.currentUser?.uid)!
        
        // Haal de gegevens van de gebruiker op uit de database
        userDataRepository.getUser(userId: userId) { (user) in
            // Haal de technische competenties van de gebruiker op uit de database
            self.skillsetDataRepository.getSkillset(entityId: userId, completion: { (skillset) in
                // Haal de karaktereigenschappen van de gebruiker op uit de database
                self.personalityDataRepository.getPersonality(entityId: userId, completion: { (personality) in
                    self.user = user
                    self.user.addSkillset(skillset: skillset)
                    self.user.addPersonality(personality: personality)
                    
                    self.navigationItem.title = user.name
                    UserInterfaceUtility.setRoundProfilePicture(profilePicture: self.imageViewProfilePicture)
                    self.imageViewProfilePicture.layer.borderColor = user.personality?.determineDiscPersonalityStyle().color.cgColor
                    self.imageViewProfilePicture.image = UIImage(data: user.profilePicture!)
                    self.labelEmail.text = user.email
                    self.labelPhone.text = String(user.phone!)
                    
                    self.tableViewSkillset.isHidden = false
                    self.tableViewSkillset.reloadData()
                    self.tableViewPersonality.isHidden = false
                    self.tableViewPersonality.reloadData()
                    
                    self.buttonInfoDiscModel.isHidden = false
                    
                    self.activityIndicatorLoading.stopAnimating()
                })
            })
        }
    }
    
    // MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableViewSkillset) {
            return (user.skillset?.technicalCompetences.count)!
        } else {
            return (user.personality?.characterTraits.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableViewSkillset) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsetCell")! as UITableViewCell
            let currentRow = (indexPath as NSIndexPath).row
            cell.textLabel?.text = user.skillset?.technicalCompetences[currentRow]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalityCell")! as UITableViewCell
            let currentRow = (indexPath as NSIndexPath).row
            cell.textLabel?.text = user.personality?.characterTraits[currentRow]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == tableViewSkillset) {
            return "Skillset"
        } else {
            return "Personality"
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToEditContactInformationViewController") {
            let controller = segue.destination as! EditContactInformationViewController
            controller.user = self.user
        } else if (segue.identifier == "ToEditSkillsetViewController") {
            let controller = segue.destination as! EditSkillsetViewController
            controller.user = self.user
        } else if (segue.identifier == "ToEditPersonalityTableViewController") {
            let controller = segue.destination as! EditPersonalityTableViewController
            controller.user = self.user
        }
    }

}
