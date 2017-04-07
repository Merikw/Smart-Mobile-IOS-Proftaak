//
//  ProjectsTableViewController.swift
//  TeamUp
//
//  Created by Fhict on 11/12/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var projects = [Project]()
    
    //Data repository
    let projectDataRepository = ProjectDataRepository(context: ProjectFirebaseDataContext())
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProjects()
    }
    
    func updateProjects() {
        projectDataRepository.getAllProjects { (projects) in
            self.projects = projects
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")! as UITableViewCell
        let currentRow = (indexPath as NSIndexPath).row
        cell.textLabel?.text = projects[currentRow].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let currentRow = (indexPath as NSIndexPath).row
        projectDataRepository.removeProject(projectId: projects[currentRow].id!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToDetailProfileViewController", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToDetailProfileViewController") {
            let indexPath = tableView?.indexPath(for: sender as! UITableViewCell)
            let controller = segue.destination as! DetailProjectViewController
            controller.project = projects[(indexPath?.row)!]
        }
    }
    
}
