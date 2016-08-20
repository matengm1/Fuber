//
//  GroupSelectorViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/18/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class GroupSelectorViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    enum GroupSelectorError: ErrorType {
        case NoLocation
        case OutOfStock
    }
    
//    let frandClass = PFQuery(className: "GroupsList")
    let friendClass = PFQuery(className: "GroupsList")
    let altFriendClass = PFQuery(className: "GroupsList")
//    var groupsArray = NSMutableArray()
    var groupsArray = [PFObject]()
    var groupsListArray = [PFObject]()
    var friendCount = 0
    var userLocation : CLLocation?
    var locationsArray = [PFGeoPoint]()
    var rowPosition = 0
    var group : PFObject?
    var requestingArray = [Bool]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToGroupSelectorViewController(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
//        let altUserQuery = altFriendClass.whereKey("fromUser", equalTo: PFUser.currentUser()!)
//        let userQuery = friendClass.whereKey("fromUser", equalTo: PFUser.currentUser()!)
//        
//          altFriendClass.findObjectsInBackgroundWithBlock { (users, error) in
//            for user in users! {
//                print(self.groupsArray)
//
//            }
//            self.tableView.reloadData()
//        }
//        
//        userQuery.countObjectsInBackgroundWithBlock { (count, error) in
//            if error == nil {
//                if count != 0 {
//                    self.friendCount = Int(count)
//                } else {
//                    self.friendCount = 2
//                }
//                self.tableView.reloadData()
//            }
//        }
//        if (PFUser.currentUser() == nil) {
//            let loginViewController = PFLogInViewController()
//            loginViewController.delegate = self
//            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten]
//            loginViewController.emailAsUsername = true
//            loginViewController.signUpController?.delegate = self
//            self.presentViewController(loginViewController, animated: false, completion: nil)
//        } else {
//            presentLoggedInAlert()
//        }
//        
        
        
//        let query = friendClass.whereKey("Creator", equalTo: PFUser.currentUser()!)
        let query = PFQuery(className: "Groups").whereKey("fromUser", equalTo: PFUser.currentUser()!)
//        query.includeKey("requestFromUser")
        query.includeKey("fromUser")
        query.includeKey("toGroup")
        query.findObjectsInBackgroundWithBlock { (results : [PFObject]?, error) in
            self.groupsArray = results!
//            self.groupsListArray = results!["toGroup"]
            self.tableView.reloadData()
        }
        
        
//        let groupsListQuery = PFQuery(className: "GroupsList").whereKey("fromUser", equalTo: PFUser.currentUser()!)
//        //        query.includeKey("requestFromUser")
//        query.includeKey("fromUser")
//        query.includeKey("toGroup")
//        query.findObjectsInBackgroundWithBlock { (results : [PFObject]?, error) in
//            self.groupsArray = results!
//            self.tableView.reloadData()
//        }
    }
}

extension GroupSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupTableViewCell", forIndexPath: indexPath) as! GroupTableViewCell
        
        
        group = groupsArray[indexPath.row]
        cell.group = group
        print((group?.objectId)! + "is the current objectId")
        requestingArray.append(group!["isRequesting"] as! Bool)
        
        if let realGroup = group!["toGroup"] as! PFObject? {
            print(realGroup)
        }

        if let requestFromUser = group!["requestFromUser"] as! PFUser? {
            locationsArray.append(requestFromUser["location"] as! PFGeoPoint)
            let userLocationGeopoint : PFGeoPoint? = locationsArray[indexPath.row]
            self.getRequestedLocation(group!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("mapSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Make sure your segue name in storyboard is the same as this line
        if (segue.identifier == "mapSegue") {
            if let destination = segue.destinationViewController as? MapViewController {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                destination.group = groupsArray[(path?.row)!]
                print((destination.group?.objectId)! + "is the selected group")
                if (requestingArray[path!.row]) {
//                    print(group?.objectId)
                    destination.userLocation = CLLocation(latitude: locationsArray[path!.row].latitude, longitude: locationsArray[path!.row].longitude)
                } else {
                    destination.userLocation = nil
                }
            }
        }
    }
}

// MARK: Pulling Map Data
extension GroupSelectorViewController {
    func getRequestedLocation (group: PFObject) {
        if group["isRequesting"] as! Bool == true {
            let requestingUser = group["requestFromUser"] as! PFUser
            let userLocGeopoint = requestingUser["location"] as! PFGeoPoint
            userLocation = CLLocation(latitude: userLocGeopoint.latitude, longitude: userLocGeopoint.longitude)
            
        } else {
//            print("No Request")
        }
    }
}

// MARK: Style
extension GroupSelectorViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

//MARK: Login
//extension GroupSelectorViewController {
//    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        presentLoggedInAlert()
//    }
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        presentLoggedInAlert()
//    }
//    
//    func presentLoggedInAlert() {
//        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Vay.K", preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        alertController.addAction(OKAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//}