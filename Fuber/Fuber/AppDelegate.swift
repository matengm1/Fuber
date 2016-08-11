//
//  AppDelegate.swift
//  Fuber
//
//  Created by Matt Eng on 7/11/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import GoogleMaps
import GoogleMapsDirections
import Parse
import ParseUI
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var parseLoginHelper: ParseLoginHelper!
    var window: UIWindow?
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("mainGroup")
                // 3
                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        GMSServices.provideAPIKey("AIzaSyA5Oihzj42UfNNXIwRihjNoVnKzG_O1DZ0")
        GoogleMapsDirections.provideAPIKey("AIzaSyA5Oihzj42UfNNXIwRihjNoVnKzG_O1DZ0")
        
//        let configuration = ParseClientConfiguration {
//            $0.applicationId = "fuber"
//            $0.server = "https://matthew-eng-fuber.herokuapp.com/parse"
//        }
//        Parse.initializeWithConfiguration(configuration)
//        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Set up the Parse SDK
        let configuration = ParseClientConfiguration {
            $0.applicationId = "fuber"
            $0.server = "https://matthew-eng-fuber.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        let acl = PFACL()
        acl.publicReadAccess = true
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
//        // Initialize Facebook
//        // 1
//        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
//
//        
//        // check if we have logged in user
//        // 2
//        let user = PFUser.currentUser()
//        if user != nil {
//            PFFacebookUtils.linkUserInBackground(user!, withReadPermissions: ["email", "name"])
//        }
//        let startViewController: UIViewController;
//        
//        if (user != nil) {
//            // 3
//            // if we have a user, set the TabBarController to be the initial view controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("mainGroup") as! UITabBarController
//            print(user?.email)
////            let groupVC = storyboard.instantiateViewControllerWithIdentifier("mainGroup")
////            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
////            delegate.window?.rootViewController = groupVC
////            delegate.window?.makeKeyAndVisible()
//
//            
//        } else {
//            // 4
//            // Otherwise set the LoginViewController to be the first
//            let loginViewController = PFLogInViewController()
//            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten]
//            loginViewController.delegate = parseLoginHelper
//            loginViewController.signUpController?.delegate = parseLoginHelper
//            
//            startViewController = loginViewController
//        }
//        
//        // 5
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = startViewController;
//        self.window?.makeKeyAndVisible()
        
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController;
        
        if (user != nil) {
            // 3
            // if we have a user, set the TabBarController to be the initial view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("mainGroup") as! UITabBarController
        } else {
            // 4
            // Otherwise set the LoginViewController to be the first
            let loginViewController = LogInViewController()
            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten]
            loginViewController.delegate = parseLoginHelper
            loginViewController.signUpController?.delegate = parseLoginHelper
            
            startViewController = loginViewController
        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        // make white the default color for selected tab bar entries
//        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        var handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
//
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application,
//                                                                     openURL: url,
//                                                                     sourceApplication: sourceApplication,
//                                                                     annotation: annotation)
//    }
//    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

