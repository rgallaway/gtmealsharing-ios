//
//  SecondViewController.swift
//  MealSharing
//
//  Created by Ryan Gallaway on 2/23/18.
//  Copyright © 2018 MealSharing. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            label.text = "Logged in as \(user.displayName ?? "nil")"
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let auth = Auth.auth()
        try! auth.signOut()
        performSegue(withIdentifier: "didLogOut", sender: self)
    }
}

