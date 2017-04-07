//
//  DetailPeopleViewController.swift
//  TeamUp
//
//  Created by Fhict on 01/12/16.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class DetailPeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var tableViewSkillset: UITableView!
    @IBOutlet weak var tableViewPersonality: UITableView!
    
    var user = User()
    
    // MARK: Actions
    
    @IBAction func buttonEmailTapped(_ sender: UIButton) {
        print("email")
    }
    
    @IBAction func buttonPhoneTapped(_ sender: UIButton) {
        print("call")
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorLoading.startAnimating()
        
        navigationItem.title = user.name
        UserInterfaceUtility.setRoundProfilePicture(profilePicture: self.imageViewProfilePicture)
        imageViewProfilePicture.layer.borderColor = user.personality?.determineDiscPersonalityStyle().color.cgColor
        imageViewProfilePicture.image = UIImage(data: user.profilePicture!)
        
        if(!(user.email?.isEmpty)!) {
            buttonEmail.setTitle(user.email, for: .normal)
            buttonEmail.isHidden = false
        }
        if(!(user.phone?.isEmpty)!) {
            buttonPhone.setTitle(user.phone, for: .normal)
            buttonPhone.isHidden = false
        }
        
        tableViewSkillset.dataSource = self
        tableViewSkillset.delegate = self
        tableViewSkillset.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewSkillset.allowsSelectionDuringEditing = false
        tableViewSkillset.isHidden = false
        tableViewSkillset.reloadData()
        
        tableViewPersonality.dataSource = self
        tableViewPersonality.delegate = self
        tableViewPersonality.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewPersonality.allowsSelectionDuringEditing = false
        tableViewPersonality.isHidden = false
        tableViewPersonality.reloadData()
        
        activityIndicatorLoading.stopAnimating()
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

}
