//
//  TempGroupCreatorViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/29/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Parse


class AddToGroupViewController : UIViewController {
    
    
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToGroup", sender: self)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func unwindToGroupName(segue: UIStoryboardSegue) {}
    // stores all the users that match the current search query
    var otherusers: [PFUser]?
    var users: [PFUser]?
    var titleLabelText: String?
    
    /*
     This is a local cache. It stores all the users this user is following.
     It is used to update the UI immediately upon user interaction, instead of waiting
     for a server response.
     */
    var followingUsers: [PFUser]? {
        didSet {
            /**
             the list of following users may be fetched after the tableView has displayed
             cells. In this case, we reload the data to reflect "following" status
             */
            tableView.reloadData()
        }
    }
    
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    
    // this view can be in two different states
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                ParseHelper.allFriends(updateList)
                
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: Update userlist
    
    /**
     Is called as the completion block of all queries.
     As soon as a query completes, this method updates the Table View.
     */
    func updateList(results: [PFObject]?, error: NSError?) {
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
        guard let results = results else { return }
        
        let toUsers = results.map { $0["toUser"] as! PFUser }
        self.users = toUsers
        
        ////        self.users = results.map { $0["toUser"] as! PFUser }
        ////        self.users = results as? [PFUser] ?? []
        ////        for result in results {
        //            var objects: [PFObject] = results
        //            var userQuery: PFQuery = PFUser.query()!
        //        for object in objects {
        //            userQuery.whereKey("objectId", equalTo: (object["toUser"].objectId!)!)
        //        }
        //
        //        userQuery.includeKey("toUser")
        //
        //        userQuery.findObjectsInBackgroundWithBlock({ (foundUsers, error) in
        //            self.users = foundUsers as? [PFUser]
        //            print(self.users, "Weeeeee")
        //            self.tableView.reloadData()
        //        })
        //
        self.tableView.reloadData()
    }
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .DefaultMode
        
        // fill the cache of a user's followees
        ParseHelper.getGroupUsersForUser(PFUser.currentUser()!) {
            (results: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else { ErrorHandling.defaultErrorHandler(error!); return }
            
            let relations = results ?? []
            // use map to extract the User from a Follow object
            self.followingUsers = relations.map {
                $0.objectForKey(ParseHelper.ParseFollowToUser) as! PFUser
            }
            
        }
    }
    
    override func viewDidLoad() {
        titleLabel.text = titleLabelText!
    }
    
    @IBAction func createButtonTouched(sender: AnyObject) {
        var currentObject = ParseHelper.createGroup(titleLabel.text!, creator: PFUser.currentUser()!)
        // ADD CREATOR OBJECT
        let creatorObject = PFObject(className: "Groups")
        creatorObject.setObject(PFUser.currentUser()!, forKey: "fromUser")
        creatorObject.setObject(currentObject, forKey: "toGroup")
//        creatorObject.saveInBackground()
        try! creatorObject.save()
        
        //ADD ALL OTHER USERS IN FOLLOWING USERS
        if followingUsers! != [] {
            for user in followingUsers! {
//                print(currentObject)
                print(user)
                var followObject = PFObject(className: "Groups")
//                followObject.setObject(try! user.fetch(), forKey: "fromUser")
                print(followingUsers)
                followObject.setObject(user, forKey: "fromUser")
                followObject.setObject(currentObject, forKey: "toGroup")
//                followObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
                try! followObject.save()
                print("Following")
            }
        }
        //UNWIND BACK TO THE PREVIOUS VIEW
        self.performSegueWithIdentifier("unwindToGroup", sender: self)
    }
}

// MARK: TableView Data Source

extension AddToGroupViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddPeopleTableViewCell") as! TempAddToGroupTableViewCell
        //        print(users)
        
        
        
        
        let user = users![indexPath.row]
        
        
        
        
        
        //        var userObject = PFUser.query()!.whereKey("objectId", equalTo: user["objectId"])
        //        print(userName)
        //        do {
        //            let results : [PFUser] = try userName.findObjects() as! [PFUser]
        //            cell.user = results[indexPath.row]
        //        } catch {
        ////            return nil
        //        }
        //        nameLabel.text = results.username
        
        
        cell.user = user
        
        
        if let followingUsers = followingUsers {
            // check if current user is already following displayed user
            // change button appereance based on result
            
            
            
            
            cell.canFollow = !followingUsers.contains(user)
        }
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: Searchbar Delegate

extension AddToGroupViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.searchUsers(searchText, completionBlock:updateList)
    }
    
}

// MARK: FriendSearchTableViewCell Delegate

extension AddToGroupViewController: TempAddToGroupTableViewCellDelegate {
    
    func cell(cell: TempAddToGroupTableViewCell, didSelectFollowUser user: PFUser) {
        ParseHelper.addGroupRelationshipFromUser(PFUser.currentUser()!, toGroup: user)
        // update local cache
        followingUsers?.append(user)
        for userpeople in followingUsers! {
            print(userpeople)
        }
    }
    
    func cell(cell: TempAddToGroupTableViewCell, didSelectUnfollowUser user: PFUser) {
        if let followingUsers = followingUsers {
            ParseHelper.removeGroupRelationshipFromUser(PFUser.currentUser()!, toGroup: user)
            // update local cache
            self.followingUsers = followingUsers.filter({$0 != user})
            for userpeople in followingUsers {
                print(userpeople)
            }
        }
    }
    
}