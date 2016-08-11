//
//  SettingsViewController.swift
//  Fuber
//
//  Created by Matt Eng on 8/11/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SettingsViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {
    @IBOutlet weak var nameLabel: UILabel!
//
//    @IBAction func LogoutButtonTouched(sender: AnyObject) {
//        PFUser.logOut()
//        
//        self.loginSetup()
//
//    }
    
    var parseLoginHelper: ParseLoginHelper!
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = PFUser.currentUser()?.username
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginSetup()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    // MARK: - Parse Login
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        print("FAiled to login...")
    }
    
    // MARK: - Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        print("Faild to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        print("User dismissed sign up.")
    }
    
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        
        PFUser.logOut()
        
        self.loginSetup()
        
    }
    
    func loginSetup() {
        
        if (PFUser.currentUser() == nil) {
            
            var logInViewController = LogInViewController()
            logInViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten]
            
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
            
        }
        
    }


}
