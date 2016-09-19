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
    
    let friendClass = PFQuery(className: "GroupsList")
    let altFriendClass = PFQuery(className: "GroupsList")
    var groupsArray = [PFObject]()
    var groupsListArray = [PFObject]()
    var friendCount = 0
    var userLocation : CLLocation?
    var locationsArray = [PFGeoPoint]()
    var rowPosition = 0
    var group : PFObject?
    var requestingArray = [Bool]()
    var newUserLocation : PFGeoPoint?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToGroupSelectorViewController(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        let query = PFQuery(className: "Groups").whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.includeKey("fromUser")
        query.includeKey("toGroup")
        query.findObjectsInBackgroundWithBlock { (results : [PFObject]?, error) in
            self.groupsArray = results!
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // MARK: Querying For The User's Groups
        requestingArray = []
        locationsArray = []
        groupsListArray = []
        let query = PFQuery(className: "Groups").whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.includeKey("fromUser")
        query.includeKey("toGroup")

        self.groupsArray = try! query.findObjects()
        
        self.tableView.reloadData()
        print("TABLEVIEW RELOADED")
    }
}

extension GroupSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupTableViewCell", forIndexPath: indexPath) as! GroupTableViewCell
        print("hi")
        let queryGroup = try! PFQuery(className: "GroupsList").includeKey("requestFromUser").getObjectWithId(((groupsArray[indexPath.row]["toGroup"] as? PFObject)?.objectId)!)
        group = queryGroup
        groupsListArray.append(group!)
        print(groupsListArray)
        if let requestUserExists = queryGroup["requestFromUser"]{
        print(queryGroup["requestFromUser"])
        cell.group = queryGroup
        print(queryGroup)
        print((queryGroup["requestFromUser"] as! PFUser).username)
        requestingArray.append(queryGroup["isRequesting"] as! Bool)
        print(requestingArray)

        if let requestFromUser = queryGroup["requestFromUser"] as! PFUser? {
            locationsArray.append(requestFromUser["location"] as! PFGeoPoint)
            let userLocationGeopoint : PFGeoPoint? = locationsArray[indexPath.row]
            self.getRequestedLocation(queryGroup)
        }
        newUserLocation = (queryGroup["requestFromUser"] as! PFUser?)!["location"] as! PFGeoPoint
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
//                destination.group = group
                destination.group = groupsListArray[path!.row]
//                print(groupsListArray as! [PFObject])
//                if (requestingArray[path!.row] && requestingArray != []) {
                print(groupsListArray[path!.row]["Name"], groupsListArray[path!.row]["isRequesting"] as! Bool)
                if (groupsListArray[path!.row]["isRequesting"] as! Bool) {
                    destination.userLocation = CLLocation(latitude: newUserLocation!.latitude, longitude: newUserLocation!.longitude)
//                    destination.userLocation = CLLocation(latitude: locationsArray[path!.row].latitude, longitude: locationsArray[path!.row].longitude)
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
            print(userLocGeopoint)
            userLocation = CLLocation(latitude: userLocGeopoint.latitude, longitude: userLocGeopoint.longitude)
        }
    }
}

// MARK: Style
extension GroupSelectorViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}