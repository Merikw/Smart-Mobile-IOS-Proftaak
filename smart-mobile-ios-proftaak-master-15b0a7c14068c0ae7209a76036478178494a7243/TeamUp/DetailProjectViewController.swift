//
//  DetailProjectViewController.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit
import Firebase

class DetailProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorPeopleLoading: UIActivityIndicatorView!
    @IBOutlet weak var buttonEnroll: UIButton!
    @IBOutlet var collectionViewPeople: UICollectionView!
    @IBOutlet weak var tableViewSkillset: UITableView!
    @IBOutlet weak var tableViewPersonality: UITableView!
    
    var project = Project()
    var userId = ""
    var userEnrolled = false
    var enrolledUsers = [User]()
    
    // Data repositories
    let userDataRepository = UserDataRepository(context: UserFirebaseDataContext())
    let enrollmentDataRepository = EnrollmentDataRepository(context: EnrollmentFirebaseDataContext())
    let skillsetDataRepository = SkillsetDataRepository(context: SkillsetFirebaseDataContext())
    let personalityDataRepository = PersonalityDataRepository(context: PersonalityFirebaseDataContext())
    
    // MARK: Actions
    
    @IBAction func didTapButtonEdit(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Edit project", message: "What do you want to edit?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let skillset = UIAlertAction(title: "Required skillset", style: .default) { (action) in
            self.performSegue(withIdentifier: "ToEditSkillsetViewController", sender: self)
        }
        let personality = UIAlertAction(title: "Required personality", style: .default) { (action) in
            self.performSegue(withIdentifier: "ToEditPersonalityTableViewController", sender: self)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        actionSheet.addAction(skillset)
        actionSheet.addAction(personality)
        actionSheet.addAction(cancel)
                
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didTapButtonEnroll(_ sender: UIButton) {
        if (userEnrolled) {
            enrollmentDataRepository.withdrawFromProject(projectId: project.id!, userId: userId)
        } else {
            enrollmentDataRepository.enrollInProject(projectId: project.id!, userId: userId)
        }
        
        viewDidAppear(true)
        
        collectionViewPeople.reloadData()
        
        for cell in tableViewSkillset.visibleCells {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        for cell in tableViewPersonality.visibleCells {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewPeople.delegate = self
        collectionViewPeople.dataSource = self
        
        tableViewSkillset.dataSource = self
        tableViewSkillset.delegate = self
        tableViewSkillset.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewSkillset.allowsSelectionDuringEditing = false
        
        tableViewPersonality.dataSource = self
        tableViewPersonality.delegate = self
        tableViewPersonality.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewPersonality.allowsSelectionDuringEditing = false
        
        userId = (FIRAuth.auth()?.currentUser?.uid)!
        
        activityIndicatorLoading.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enrolledUsers = [User]()
        
        // Haal de vereiste technische competenties van het project op uit de database
        self.skillsetDataRepository.getSkillset(entityId: project.id!, completion: { (skillset) in
            // Haal de vereiste karaktereigenschappen van het project op uit de database
            self.personalityDataRepository.getPersonality(entityId: self.project.id!, completion: { (personality) in
                self.project.addSkillset(skillset: skillset)
                self.project.addPersonality(personality: personality)
                // Haal alle projectleden op uit de database
                self.enrollmentDataRepository.getCurrentEnrollment(projectId: self.project.id!, completion: { (currentEnrollment) in
                    var userCounter = 0
                    
                    for enrollment in currentEnrollment {
                        self.activityIndicatorPeopleLoading.startAnimating()

                        userCounter += 1
                        
                        self.userDataRepository.getUser(userId: enrollment) { (user) in
                            // Haal de technische competenties van de projectledenn op uit de database
                            self.skillsetDataRepository.getSkillset(entityId: enrollment, completion: { (skillset) in
                                // Haal de karaktereigenschappen van de projectledenn op uit de database
                                self.personalityDataRepository.getPersonality(entityId: enrollment, completion: { (personality) in
                                    let user = user
                                    user.addSkillset(skillset: skillset)
                                    user.addPersonality(personality: personality)
                                    self.enrolledUsers.append(user)
                                    
                                    // Controleer of de vereiste technische competenties van het project worden afgedekt door de projectleden
                                    for technicalCompetence in (user.skillset?.technicalCompetences)! {
                                        if (self.project.skillset?.technicalCompetences.contains(technicalCompetence))! {
                                            self.setCheckmark(checkable: technicalCompetence, tableView: self.tableViewSkillset)
                                        }
                                    }
                                    
                                    // Controleer of de vereiste karaktereigenchappen van het project worden afgedekt door de projectleden
                                    for characterTrait in (user.personality?.characterTraits)! {
                                        if (self.project.personality?.characterTraits.contains(characterTrait))! {
                                            self.setCheckmark(checkable: characterTrait, tableView: self.tableViewPersonality
                                            )
                                        }
                                    }
                                    
                                    if (userCounter == currentEnrollment.count) {
                                        // Sorteer de collectie van gebruikers op alfabetische volgorde
                                        self.enrolledUsers = self.enrolledUsers.sorted { $0.name! < $1.name! }
                                        
                                        self.collectionViewPeople.reloadData()
                                        self.activityIndicatorPeopleLoading.stopAnimating()
                                    }
                                })
                            })
                        }
                    }
                    
                    // Controleer of de gebruiker zelf deel neemt aan het project
                    self.userEnrolled = false
                    for enrollment in currentEnrollment {
                        if (enrollment == self.userId) {
                            self.userEnrolled = true
                        }
                    }
                    
                    // Bepaald of de 'enroll' of 'withdraw' knop moet worden getoond op basis van of de gebruiker zelf deel neemt aan het project
                    if(self.userEnrolled) {
                        self.buttonEnroll.setTitle("Withdraw from project", for: .normal)
                        self.buttonEnroll.setTitleColor(UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
                    } else {
                        self.buttonEnroll.setTitle("Enroll in project", for: .normal)
                        self.buttonEnroll.setTitleColor(UIColor(red:45/255, green:195/255, blue: 106/255, alpha: 1), for: .normal)
                    }
                    
                    self.navigationItem.title = self.project.name
                    self.labelTitle.isHidden = false
                    self.buttonEnroll.isHidden = false
                    self.tableViewSkillset.isHidden = false
                    self.tableViewSkillset.reloadData()
                    self.tableViewPersonality.isHidden = false
                    self.tableViewPersonality.reloadData()
                    self.activityIndicatorLoading.stopAnimating()
                })
            })
        })
    }
    
    func setCheckmark(checkable: String, tableView: UITableView) {
        for cell in tableView.visibleCells {
            if (checkable == cell.textLabel?.text!) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                cell.tintColor = UIColor(red: 57/255, green: 170/255, blue: 53/255, alpha: 1)
            }
        }
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.enrolledUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPeople.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        // Toon enkel de voornaam van de gebruiker door de volledige naam te splitsen op de spatie
        let name = enrolledUsers[indexPath.row].name
        let nameArray = name?.characters.split{$0 == " "}.map(String.init)
        cell.labelUserName?.text = nameArray?[0]
        cell.imageViewProfilePicture?.image =  UIImage(data: enrolledUsers[indexPath.row].profilePicture!)
        cell.imageViewProfilePicture?.layer.borderColor = enrolledUsers[indexPath.row].personality?.determineDiscPersonalityStyle().color.cgColor
        
        return cell
    }
    
    // MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableViewSkillset) {
            return (project.skillset?.technicalCompetences.count)!
        } else {
            return (project.personality?.characterTraits.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableViewSkillset) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsetCell")! as UITableViewCell
            let currentRow = (indexPath as NSIndexPath).row
            cell.textLabel?.text = project.skillset?.technicalCompetences[currentRow]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalityCell")! as UITableViewCell
            let currentRow = (indexPath as NSIndexPath).row
            cell.textLabel?.text = project.personality?.characterTraits[currentRow]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == tableViewSkillset) {
            return "Required skillset"
        } else {
            return "Required personality"
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToEditSkillsetViewController") {
            let controller = segue.destination as! EditSkillsetViewController
            controller.project = self.project
        } else if (segue.identifier == "ToEditPersonalityTableViewController") {
            let controller = segue.destination as! EditPersonalityTableViewController
            controller.project = self.project
        }
    }
    
}
