//
//  GroupCreatorViewController.swift
//  Fuber
//
//  Created by Matt Eng on 7/18/16.
//  Copyright © 2016 EngTech. All rights reserved.
//












//import Foundation
//import UIKit
//import Firebase
//import Parse
//
//class GroupCreatorViewController: UIViewController {
//    
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
//    
//    // stores all the users that match the current search query
//    var users: [PFObject]?
//    
//    /*
//     This is a local cache. It stores all the users this user is following.
//     It is used to update the UI immediately upon user interaction, instead of waiting
//     for a server response.
//     */
//    var followingUsers: [PFUser]? {
//        didSet {
//            /**
//             the list of following users may be fetched after the tableView has displayed
//             cells. In this case, we reload the data to reflect "following" status
//             */
//            tableView.reloadData()
//        }
//    }
//    
//    // the current parse query
//    var query: PFQuery? {
//        didSet {
//            // whenever we assign a new query, cancel any previous requests
//            oldValue?.cancel()
//        }
//    }
//    
//    // this view can be in two different states
//    enum State {
//        case DefaultMode
//        case SearchMode
//    }
//    
//    // whenever the state changes, perform one of the two queries and update the list
//    var state: State = .DefaultMode {
//        didSet {
//            switch (state) {
//            case .DefaultMode:
//                query = ParseHelper.allFriends(updateList)
//            case .SearchMode:
//                let searchText = searchBar?.text ?? ""
//                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
//            }
//        }
//    }
//    
//    // MARK: Update userlist
//    
//    /**
//     Is called as the completion block of all queries.
//     As soon as a query completes, this method updates the Table View.
//     */
//    func updateList(results: [PFObject]?, error: NSError?) {
//        if let error = error {
//            ErrorHandling.defaultErrorHandler(error)
//        }
//        
//        self.users = results ?? []
//        self.tableView.reloadData()
//        
//    }
//    
//    // MARK: View Lifecycle
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        state = .DefaultMode
//        
//        // fill the cache of a user's followees
//        ParseHelper.getGroupUsersForUser(PFUser.currentUser()!) {
//            (results: [PFObject]?, error: NSError?) -> Void in
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//            }
//            let relations = results ?? []
//            // use map to extract the User from a Follow object
//            self.followingUsers = relations.map {
//                $0.objectForKey(ParseHelper.ParseFollowToUser) as! PFUser
//            }
//            
//        }
//    }
//    
//}
//
//// MARK: TableView Data Source
//
//extension GroupCreatorViewController: UITableViewDataSource {
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.users?.count ?? 0
////        return 2
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("AddPeopleTableViewCell") as! AddToGroupTableViewCell
//        
//        let user = users![indexPath.row]
//        cell.user = user
//        
//        if let followingUsers = followingUsers {
//            // check if current user is already following displayed user
//            // change button appereance based on result
//            cell.canFollow = !followingUsers.contains(user)
//        }
//        
//        cell.delegate = self
//        
//        return cell
//    }
//}
//
//// MARK: Searchbar Delegate
//
//extension GroupCreatorViewController: UISearchBarDelegate {
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//        state = .SearchMode
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.text = ""
//        searchBar.setShowsCancelButton(false, animated: true)
//        state = .DefaultMode
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        ParseHelper.searchUsers(searchText, completionBlock:updateList)
//    }
//    
//}
//
//// MARK: FriendSearchTableViewCell Delegate
//
//extension GroupCreatorViewController: AddToGroupTableViewCellDelegate {
//    
//    func cell(cell: AddToGroupTableViewCell, didSelectFollowUser user: PFUser) {
//        ParseHelper.addFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
//        // update local cache
//        followingUsers?.append(user)
//    }
//    
//    func cell(cell: AddToGroupTableViewCell, didSelectUnfollowUser user: PFUser) {
//        if let followingUsers = followingUsers {
//            ParseHelper.removeFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
//            // update local cache
//            self.followingUsers = followingUsers.filter({$0 != user})
//        }
//    }
//    
//}
//
//// MARK: Style
//
//extension GroupCreatorViewController {
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
//}











//class GroupCreatorViewController : UIViewController {
////    let rootRef = FIRDatabase.database().reference()
////    let userID = FIRAuth.auth()?.currentUser?.uid
////    var childCount: UInt = 0
////    var userName: [String : AnyObject]?
//    var usersToCreate = [String]()
////    var friendCount = 0
////    var newArray = [String]()
//    var userArray = NSMutableArray()
//
//    @IBAction func unwindToGroup(segue : UIStoryboardSegue) {
//        
//    }
//    @IBAction func cancelButtonTouched(sender: AnyObject) {
//    }
//    @IBAction func createButtonTouched(sender: AnyObject) {
//        
//    }
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
//    
//    // stores all the users that match the current search query
//    var users: [PFUser]?
//    
//    /*
//     This is a local cache. It stores all the users this user is following.
//     It is used to update the UI immediately upon user interaction, instead of waiting
//     for a server response.
//     */
//    var followingUsers: [PFUser]? {
//        didSet {
//            /**
//             the list of following users may be fetched after the tableView has displayed
//             cells. In this case, we reload the data to reflect "following" status
//             */
//            tableView.reloadData()
//        }
//    }
//    
//    // the current parse query
//    var query: PFQuery? {
//        didSet {
//            // whenever we assign a new query, cancel any previous requests
//            oldValue?.cancel()
//        }
//    }
//    
//    // this view can be in two different states
//    enum State {
//        case DefaultMode
//        case SearchMode
//    }
//    
//    // whenever the state changes, perform one of the two queries and update the list
//    var state: State = .DefaultMode {
//        didSet {
//            switch (state) {
//            case .DefaultMode:
//                query = ParseHelper.allFriends(updateList)
//                
//            case .SearchMode:
//                let searchText = searchBar?.text ?? ""
//                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
//            }
//        }
//    }
//    
//    // MARK: Update userlist
//    
//    /**
//     Is called as the completion block of all queries.
//     As soon as a query completes, this method updates the Table View.
//     */
//    func updateList(results: [PFObject]?, error: NSError?) {
//        if let error = error {
//            ErrorHandling.defaultErrorHandler(error)
//        }
//        
//        self.users = results as? [PFUser] ?? []
//        self.tableView.reloadData()
//        
//    }
//    
//    // MARK: View Lifecycle
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        state = .DefaultMode
//        
//        // fill the cache of a user's followees
//        ParseHelper.getFollowingUsersForUser(PFUser.currentUser()!) {
//            (results: [PFObject]?, error: NSError?) -> Void in
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//            }
//            let relations = results ?? []
//            // use map to extract the User from a Follow object
//            self.followingUsers = relations.map {
//                $0.objectForKey(ParseHelper.ParseFollowToUser) as! PFUser
//            }
//            
//        }
//    }
////    override func viewDidLoad() {
////        //Searches for everyone the user is friends with, counts the number of people, and appends their names to an array
////        
////
////        
////        
////        PFUser.query()!.findObjectsInBackgroundWithBlock { (results, error) in
////            if error == nil {
////                ParseHelper.allFriends(self.updateList)
////            }
////            self.tableView.reloadData()
////        }
////    }
//}
//
//extension GroupCreatorViewController: UITableViewDataSource {
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        print((self.users?.count))
//        return (self.users?.count)!
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("AddPeopleTableViewCell", forIndexPath: indexPath) as! AddToGroupTableViewCell
////
////        cell.delegate = self
////        if userArray != [] {
////            cell.nameLabel.text = userArray[indexPath.row].username
////        }
//        
//        let user = users![indexPath.row]
//        cell.user = user
//        
//        if let followingUsers = followingUsers {
//            // check if current user is already following displayed user
//            // change button appereance based on result
//            cell.canFollow = !followingUsers.contains(user)
//        }
//        
//        cell.delegate = self
//        
//        return cell
//    }
//}
//
//extension GroupCreatorViewController: AddToGroupTableViewCellDelegate {
//    func cell(cell: AddToGroupTableViewCell, didSelectFollowUser user: PFUser) {
//        ParseHelper.addGroupRelationshipFromUser(user, toGroup: "user")
//        // update local cache
//        print("TESTING")
//        followingUsers?.append(user)
//    }
//    
//    func cell(cell: AddToGroupTableViewCell, didSelectUnfollowUser user: PFUser) {
//        if let followingUsers = followingUsers {
//            ParseHelper.removeGroupRelationshipFromUser(user, toGroup: "user")
//            // update local cache
//            print("TESTING2")
//            self.followingUsers = followingUsers.filter({$0 != user})
//        }
//    }
//}
//
//extension GroupCreatorViewController: UISearchBarDelegate {
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//        state = .SearchMode
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.text = ""
//        searchBar.setShowsCancelButton(false, animated: true)
//        state = .DefaultMode
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        ParseHelper.searchUsers(searchText, completionBlock:updateList)
//    }
//    
//}
//
//
////extension GroupCreatorViewController: AddToGroupTableViewCellDelegate {
////    
////    func cell(cell: AddToGroupTableViewCell, didSelectFollowUser user: PFUser) {
////////        ParseHelper.addFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
//////        
//////        let followObject = PFObject(className: "Groups")
//////        followObject.setObject(user, forKey: "fromUser")
////////        followObject.setObject("GroupOne", forKey: "toGroup")
//////        followObject.setObject(true, forKey: "isModerator")
//////        
////////        followObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//////        
//////        // update local cache
//////        followingUsers?.append(user)
////    }
////    
////    func cell(cell: AddToGroupTableViewCell, didSelectUnfollowUser user: PFUser) {
//////        if let followingUsers = followingUsers {
////////            ParseHelper.removeFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
////////             update local cache
//////            
//////            let query = PFQuery(className: "Groups")
//////            query.whereKey("fromUser", equalTo:user)
//////            query.whereKey("toGroup", equalTo: "GroupOne")
//////
//////            query.findObjectsInBackgroundWithBlock {
//////                (results: [PFObject]?, error: NSError?) -> Void in
//////                if let error = error {
//////                    ErrorHandling.defaultErrorHandler(error)
//////                }
//////                
//////                let results = results ?? []
//////                
//////                for follow in results {
//////                    follow.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//////                }
//////            }
//////            self.followingUsers = followingUsers.filter({$0 != user})
//////        }
////    }
////    
////}