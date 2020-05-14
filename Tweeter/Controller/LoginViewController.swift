//
//  LoginViewController.swift
//  Tweeter
//
//  Created by Philip Yu on 5/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Constants.makeButtonRounded(loginButton, roundness: 25)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check if user is already authenticated and authorized access to account
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            print("[\(type(of: self))] User previously authenticated and given authority to access account...")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        print("[\(type(of: self))] Login button pressed.")
        
        // Do an authentication and authorization check
        TwitterAPICaller.client?.login(url: Constants.authURL, success: {
            // Sign in if user is authenticated and authorized to access acount
            print("[\(type(of: self))] Successfully logged onto Twitter.")
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self) 
        }, failure: { (error) in
            print("[\(type(of: self))] Failed to login, \(error)")
        })
        
    }
    
}
