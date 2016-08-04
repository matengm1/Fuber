//
//  SettingsViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/13/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Firebase
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    @IBAction func createGroupButtonTouched(sender: AnyObject) {
        performSegueWithIdentifier("CreateGroupSegue", sender: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var rootRef : FIRDatabaseReference!

    override func viewDidLoad() {
        rootRef = FIRDatabase.database().reference()
        nameLabel.text = FIRAuth.auth()?.currentUser?.displayName
        
//        var loginButton: FBSDKLoginButton = FBSDKLoginButton()
//        // Optional: Place the button in the center of your view.
//        loginButton.center = self.view.center
//        self.view!.addSubview(loginButton)
    }
}