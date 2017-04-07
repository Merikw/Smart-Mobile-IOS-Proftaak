//
//  LoginViewController.swift
//  TeamUp
//
//  Created by Fhict on 25/11/2016.
//  Copyright © 2016 TeamUp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var labelBannerText: UILabel!
    
    // Data repository
    let userDataRepository = UserDataRepository(context: UserFirebaseDataContext())
    
    var user = User()
    var loginButton = FBSDKLoginButton()
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Stel anti aliasing (smoothing) in voor het logo
        imageViewLogo.layer.minificationFilter = kCAFilterTrilinear
        
        // Verberg de Login view componenten
        loginButton.isHidden = true
        imageViewLogo.isHidden = true
        labelBannerText.isHidden = true
        
        // Controleer of er een gebruiker is ingelogd
        if let userId = FIRAuth.auth()?.currentUser?.uid {
            userDataRepository.checkIfUserExists(userId: userId, completion: { (userExists) in
                if (userExists) {
                    // Navigeer naar de Projects view
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let projectsViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                    self.present(projectsViewController, animated: false , completion: nil)
                } else {
                    // Log huidige gebruiker uit op Firebase
                    try! FIRAuth.auth()!.signOut()
                    // Log huidige gebruiker uit op Facebook
                    FBSDKAccessToken.setCurrent(nil)
                    
                    self.showFacebookLoginButton()
                }
            })
        } else {
            showFacebookLoginButton()
        }
    }
    
    func showFacebookLoginButton() {
        // Centreer de Facebook login knop in het midden van het scherm
        self.loginButton.center = self.view.center
        
        // Vraag de gebruiker om zijn publieke profiel en e-mailadres te delen
        self.loginButton.readPermissions = ["public_profile", "email"]
        
        self.loginButton.delegate = self
        self.view.addSubview(self.loginButton)
        
        // Toon de Login view componenten
        self.loginButton.isHidden = false
        self.imageViewLogo.isHidden = false
        self.labelBannerText.isHidden = false
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        loginButton.isHidden = true
        activityIndicatorLoading.startAnimating()
        
        // Controleer of er errors zijn en of de gebruiker het inloggen heeft afgebroken
        if(error != nil || result.isCancelled) {
            loginButton.isHidden = false
            activityIndicatorLoading.stopAnimating()
        } else {
            // Ruil token van de ingelogde Facebook gebruiker om voor Firebase credentials
            FIRAuth.auth()?.signIn(with: FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)) { (user, error) in
                if let newUser = user {
                    self.user = User(id: newUser.uid, name: newUser.displayName!, email: newUser.email!)
                    self.performSegue(withIdentifier: "ToCompanyViewController", sender: self)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! CompanyViewController
        controller.user = self.user
    }
    
}
