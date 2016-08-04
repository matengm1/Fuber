//
//  LoginViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/11/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import Parse
import ParseUI
import ParseFacebookUtilsV4

class LoginViewController: UIViewController, PFLogInViewControllerDelegate//, FBSDKLoginButtonDelegate
{
    
//    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
//    let rootRef = FIRDatabase.database().reference()
//    var currentUser: FIRUser?

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Optional: Place the button in the center of your view.
//        self.loginButton.center = self.view.center
//        self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        self.loginButton.delegate = self
//        
//        self.view!.addSubview(loginButton)
//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            print(FBSDKAccessToken.currentAccessToken().tokenString)
////            print("Segue Performed")
////            print(FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"]))
////            print("Why yes, there is an access token")
////            self.performSegueWithIdentifier("LoginSegue", sender: nil)
//        } else {
//            print("NO SEGUE PERFORMED")
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    func showGroupTab(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let groupVC = storyboard.instantiateViewControllerWithIdentifier("mainGroup")
//        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        delegate.window?.rootViewController = groupVC
//        delegate.window?.makeKeyAndVisible()
//    }
//    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        print("user logged in")
//        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
//        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
//            print("User logged into Firebase App")
//            print(FBSDKAccessToken.currentAccessToken())
//            if (error != nil) {
//                print(error)
//            } else {
//                self.rootRef.child("users")
//                let newUser : [String: String] =
//                [
////                    "uid": (user?.uid)!,
//                    "email": (user?.email)!,
//                    "name": (user?.displayName)!
//                ]
//                print(newUser, "hi")
//                self.rootRef.child("users").child(user!.uid).updateChildValues(newUser)
//                self.currentUser = user!
//            }
//            self.showGroupTab()
////            self.performSegueWithIdentifier("LoginSegue", sender: nil)
//        }
//    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        print("user did logout")
//        
//        try! FIRAuth.auth()!.signOut()
//    }
    
    
    override func viewDidAppear(animated: Bool) {
        loadData()
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) {
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            loginViewController.fields = .Facebook
            loginViewController.facebookPermissions?.append("email")
            loginViewController.emailAsUsername = true
            self.presentViewController(loginViewController, animated: false, completion: nil)
        } else {
            presentLoggedInAlert()
//            print(PFUser.currentUser()?.username)
//            print(PFUser.currentUser()?.email)
//            print(PFUser.currentUser()?.password)
            loadData()
            showGroupTab()
        }
        
    }
    
    func showGroupTab(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let groupVC = storyboard.instantiateViewControllerWithIdentifier("mainGroup")
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.window?.rootViewController = groupVC
        delegate.window?.makeKeyAndVisible()
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Fuber", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
    }
    
    func loadData() {
        // ...
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        request.startWithCompletionHandler({(connection: FBSDKGraphRequestConnection, result: AnyObject, error: NSError?) -> Void in
        request.startWithCompletionHandler { (connection, result, error) in
            if (error == nil) {
                // result is a dictionary with the user's Facebook data
                let userData: NSDictionary = (result as! NSDictionary)
                let facebookID: String = userData["id"] as! String
                let name: String = userData["name"] as! String
//                let email: String = userData["email"] as! String
//                var location: String = userData["location"]["name"]
//                var gender: String = userData["gender"]
//                var birthday: String = userData["birthday"]
//                var relationship: String = userData["relationship_status"]
//                let pictureURL: NSURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1")!
                // Now add the data to the UI elements
                // ...
                // Now add the data to the UI elements
                // ...
//                print(name, facebookID, email)
            }
        }
    }
    
    func _logOut() {
        PFUser.logOut()
        // Log out
        // Log out
    }
}