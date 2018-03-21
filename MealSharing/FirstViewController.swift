//
//  FirstViewController.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 2/23/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class FirstViewController: UIViewController, FUIAuthDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Auth.auth().addStateDidChangeListener { auth, user in
            weak var weakSelf = self
            if user != nil {
                weakSelf!.performSegue(withIdentifier: "showMainScreen", sender: self)
            } else {
                self.login()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if (user != nil) {
            performSegue(withIdentifier: "showMainScreen", sender: self)
        } else if (error != nil) {
            self.login()
        }
    }
}

