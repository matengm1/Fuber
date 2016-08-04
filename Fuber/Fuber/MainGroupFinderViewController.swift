//
//  MainGroupFinderViewController.swift
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
import FirebaseAuth
import ParseFacebookUtilsV4
import Parse
import ParseUI

class MainGroupFinderViewController: UITabBarController, UITabBarControllerDelegate, PFLogInViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil {
            showloginScreen()
        } else {
            presentLoggedInAlert()
        }
        print(PFUser.currentUser()?.email)
////        print(PFUser.currentUser())
//        if let user = FIRAuth.auth()?.currentUser {
//            //User is signed in
//            let name = user.displayName!
//            let email = user.email!
//            print(name, email)
//            
//        } else {
//            // No user is signed in.
//            showloginScreen()
//        }
//        
//        self.delegate = self
        
//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"]).startWithCompletionHandler({ (connection, result, error) in
//                print(result)
//            })
////            print(FBSDKAccessToken.currentAccessToken())
////            print("Why yes, there is an access token")
//        } else {
//            showloginScreen()
////            print("Segue has been Performed")
//        }
    }
    
    func showloginScreen(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewControllerWithIdentifier("loginViewController")
//        let navigationVC = UINavigationController(rootViewController: loginVC)
//        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        delegate.window?.rootViewController = navigationVC
//        delegate.window?.makeKeyAndVisible()
        let loginViewController = PFLogInViewController()
        loginViewController.delegate = self
        loginViewController.fields = .Facebook
        loginViewController.emailAsUsername = true
        loginViewController.facebookPermissions?.append("public_profile")
        loginViewController.facebookPermissions?.append("email")
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Vay.K", preferredStyle: .Alert)
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
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.tabBar.invalidateIntrinsicContentSize()
//        var tabSize: CGFloat = 44.0
//        var orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
//        if orientation.isLandscape {
//            tabSize = 32.0
//        }
//        var tabFrame: CGRect = self.tabBar.frame
//        tabFrame.size.height = tabSize
//        tabFrame.origin.y = self.view.frame.origin.y + 20
//        self.tabBar.frame = tabFrame
//        self.tabBar.translucent = false
//        self.tabBar.translucent = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}