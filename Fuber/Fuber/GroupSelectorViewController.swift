//
//  GroupSelectorViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/18/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import Parse
import UIKit

class GroupSelectorViewController: UIViewController {
    
    let frandClass = PFQuery(className: "GroupsList")
    let friendClass = PFQuery(className: "GroupsList")
    let altFriendClass = PFQuery(className: "GroupsList")
//    var groupsArray = NSMutableArray()
    var groupsArray = [PFObject]()
    var friendCount = 0
    var userLocation : CLLocation?
    var locationsArray = [PFGeoPoint]()
    
    @IBOutlet weak var tableView: UITableView!
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
        let query = friendClass.whereKey("Creator", equalTo: PFUser.currentUser()!)
        query.includeKey("requestFromUser")
        query.findObjectsInBackgroundWithBlock { (results : [PFObject]?, error) in
            self.groupsArray = results!
            self.tableView.reloadData()
        }
    }
}

extension GroupSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupTableViewCell", forIndexPath: indexPath) as! GroupTableViewCell
        
        let group = groupsArray[indexPath.row]
        cell.group = group
        let requestFromUser = group["requestFromUser"] as! PFUser
        print(requestFromUser)
        locationsArray.append(requestFromUser["location"] as! PFGeoPoint)
        self.getRequestedLocation(group)
        
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
                print(userLocation)
                destination.userLocation = userLocation
                
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
            print("No Request")
        }
    }
}