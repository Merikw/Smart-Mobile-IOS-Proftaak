//
//  PeopleViewController.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var searchBarPeople: UISearchBar!
    @IBOutlet var collectionViewPeople: UICollectionView!
    
    // Data repositories
    let userDataRepository = UserDataRepository(context: UserFirebaseDataContext())
    let skillsetDataRepository = SkillsetDataRepository(context: SkillsetFirebaseDataContext())
    let personalityDataRepository = PersonalityDataRepository(context: PersonalityFirebaseDataContext())
    
    var users = [User]()
    var allUsers = [User]()
        
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarPeople.delegate = self
        collectionViewPeople.delegate = self
        collectionViewPeople.dataSource = self
        
        activityIndicatorLoading.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Haal alle gebruikers op uit de database
        userDataRepository.getAllUsers { (users) in
            self.users = users
            self.allUsers = users
            
            var userCounter = 0
            
            for user in self.users {
                self.skillsetDataRepository.getSkillset(entityId: user.id!, completion: { (skillset) in
                    self.personalityDataRepository.getPersonality(entityId: user.id!, completion: { (personality) in
                        user.addSkillset(skillset: skillset)
                        user.addPersonality(personality: personality)
                        
                        userCounter += 1
                        
                        if (userCounter == self.users.count) {
                            // Sorteer de collectie van gebruikers op alfabetische volgorde
                            self.users = users.sorted { $0.name! < $1.name! }
                            
                            self.collectionViewPeople.reloadData()
                            self.activityIndicatorLoading.stopAnimating()
                        }
                    })
                })
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users = allUsers
        
        if(!(searchText.isEmpty)){
            for user in self.users{
                var characterTraitExists = false
                for characterTrait in (user.personality?.characterTraits)! {
                    if ((characterTrait.lowercased().range(of: searchText.lowercased())) != nil){
                        characterTraitExists = true
                    }
                }
                
                var technicalCompetenceExists = false
                for technicalCompetence in (user.skillset?.technicalCompetences)! {
                    if ((technicalCompetence.lowercased().range(of: searchText.lowercased())) != nil){
                        technicalCompetenceExists = true
                    }
                }
                
                let usernameExists = (user.name?.lowercased().range(of: searchText.lowercased())) != nil
                
                if (!usernameExists && !characterTraitExists && !technicalCompetenceExists){
                    self.users.removeObject(object: user)
                }
            }
        }
        else {
            users = allUsers
        }
        self.collectionViewPeople.reloadData()
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPeople.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        // Toon enkel de voornaam van de gebruiker door de volledige naam te splitsen op de spatie
        let name = users[indexPath.row].name
        let nameArray = name?.characters.split{$0 == " "}.map(String.init)
        cell.labelUserName?.text = nameArray?[0]
        cell.imageViewProfilePicture?.image =  UIImage(data: users[indexPath.row].profilePicture!)
        cell.imageViewProfilePicture?.layer.borderColor = users[indexPath.row].personality?.determineDiscPersonalityStyle().color.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToDetailPeopleViewController", sender: self)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBarPeople.text = ""
        let indexPath = self.collectionViewPeople?.indexPath(for: sender as! UICollectionViewCell)
        let controller = segue.destination as! DetailPeopleViewController
        controller.user = users[(indexPath?.row)!]
    }
}
