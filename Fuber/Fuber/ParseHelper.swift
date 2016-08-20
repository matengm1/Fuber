//
//  ParseHelper.swift
//  Fuber
//
//  Created by Matt Eng on 7/21/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    // Group Relation
    static let ParseGroupListClass  = "GroupsList"
    static let ParseGroupName       = "Name"
    static let ParseGroupCreator    = "Creator"
    
    static let ParseGroupClass      = "Groups"
    static let ParseJoinFromUser    = "fromUser"
    static let ParseJoinToGroup     = "toGroup"
    
    // Following Relation
    static let ParseFollowClass       = "Friends"
    static let ParseFollowFromUser    = "fromUser"
    static let ParseFollowToUser      = "toUser"
    
    // Like Relation
    static let ParseLikeClass         = "Like"
    static let ParseLikeToPost        = "toPost"
    static let ParseLikeFromUser      = "fromUser"
    
    // Post Relation
    static let ParsePostUser          = "user"
    static let ParsePostCreatedAt     = "createdAt"
    
    // Flagged Content Relation
    static let ParseFlaggedContentClass    = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost   = "toPost"
    
    // User Relation
    static let ParseUserUsername      = "username"
    
    //A Query is a request, an object is a row/post
    static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        
        let friendsQuery = PFQuery(className: ParseFollowClass)
        friendsQuery.whereKey(ParseFollowFromUser, equalTo:PFUser.currentUser()!)
        friendsQuery.includeKey("toUser")
        friendsQuery.findObjectsInBackgroundWithBlock(completionBlock)
        return friendsQuery
    }
    
//    static func likePost(user: PFUser, post: Post) {
//        let likeObject = PFObject(className: ParseLikeClass)
//        likeObject[ParseLikeFromUser] = user
//        likeObject[ParseLikeToPost] = post
//        
//        likeObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//    }
    
//    static func unlikePost(user: PFUser, post: Post) {
//        let query = PFQuery(className: ParseLikeClass)
//        query.whereKey(ParseLikeFromUser, equalTo: user)
//        query.whereKey(ParseLikeToPost, equalTo: post)
//        
//        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//            }
//            
//            if let results = results {
//                for likes in results {
//                    likes.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//                }
//            }
//        }
//    }
    
//    static func likesForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
//        let query = PFQuery(className: ParseLikeClass)
//        query.whereKey(ParseLikeToPost, equalTo: post)
//        query.includeKey(ParseLikeFromUser)
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
    
    
//MARK: Following
    static func getFollowingUsersForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseFollowClass)
        
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /**
     Establishes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    static func addFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let followObject = PFObject(className: ParseFollowClass)
        followObject.setObject(user, forKey: ParseFollowFromUser)
        followObject.setObject(toUser, forKey: ParseFollowToUser)
        
        followObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
    }
    
    /**
     Deletes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    static func removeFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.whereKey(ParseFollowToUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            let results = results ?? []
            
            for follow in results {
                follow.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
            }
        }
    }
    
// MARK: Grouping
    
    /**
     Fetches all users that the provided user is following.
     
     :param: user The user whose followees you want to retrieve
     :param: completionBlock The completion block that is called when the query completes
     */
    static func createGroup(name: String, creator: PFUser) -> PFObject{
        let followObject = PFObject(className: ParseGroupListClass)
        followObject.setObject(name, forKey: ParseGroupName)
        followObject.setObject(creator, forKey: ParseGroupCreator)
        followObject.setObject(false, forKey: "isRequesting")
        try! followObject.save()
        return followObject
    }
    
    static func getGroupUsersForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: ParseFollowClass)
        
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /**
     Establishes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    static func addGroupRelationshipFromUser(user: PFUser, toGroup: PFObject) {
        let followObject = PFObject(className: ParseGroupClass)
        followObject.setObject(user, forKey: "fromUser")
        followObject.setObject(toGroup, forKey: "toGroup")
        followObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
        print("Following")
    }
    
    /**
     Deletes a follow relationship between two users.
     
     :param: user    The user that is following
     :param: toUser  The user that is being followed
     */
    static func removeGroupRelationshipFromUser(user: PFUser, toGroup: PFObject) {
        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.whereKey(ParseJoinToGroup, equalTo: toGroup)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            let results = results ?? []
            
            for follow in results {
                follow.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
            }
        }
        print("Unfollowing")
    }
    
// MARK: Users
    
    /**
     Fetch all users, except the one that's currently signed in.
     Limits the amount of users returned to 20.
     
     :param: completionBlock The completion block that is called when the query completes
     
     :returns: The generated PFQuery
     */
    static func allUsers(completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        let query = PFUser.query()!
        // exclude the current user
        query.whereKey(ParseHelper.ParseUserUsername,
                       notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    static func allOtherUsers(completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        let toUser = PFQuery(className:"Friends")
        toUser.whereKey("toUser", equalTo: PFUser.currentUser()!)
        let fromUser = PFQuery(className: "Friends")
        fromUser.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        let query = PFQuery.orQueryWithSubqueries([toUser, fromUser])
        
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    static func allFriends(completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: "Friends")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.includeKey("toUser")
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    /**
     Fetch users whose usernames match the provided search term.
     
     :param: searchText The text that should be used to search for users
     :param: completionBlock The completion block that is called when the query completes
     
     :returns: The generated PFQuery
     */
    static func searchUsers(searchText: String, completionBlock: PFQueryArrayResultBlock)
        -> PFQuery {
            /*
             NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
             Regex can be slow on large datasets. For large amount of data it's better to store
             lowercased username in a separate column and perform a regular string compare.
             */
            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
                                                 matchesRegex: searchText, modifiers: "i")
            
            query.whereKey(ParseHelper.ParseUserUsername,
                           notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending(ParseHelper.ParseUserUsername)
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }
    
    static func searchFriends(searchText: String, completionBlock: PFQueryArrayResultBlock)
        -> PFQuery {
            /*
             NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
             Regex can be slow on large datasets. For large amount of data it's better to store
             lowercased username in a separate column and perform a regular string compare.
             */
            let query = PFQuery(className: "Friends").whereKey(ParseHelper.ParseUserUsername,
                                                 matchesRegex: searchText, modifiers: "i")
            
            query.whereKey(ParseHelper.ParseUserUsername,
                           notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending(ParseHelper.ParseUserUsername)
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }
    
    
//MARK: Flagging
    
//    static func flagPost(user: PFUser, post: Post) {
//        let flagObject = PFObject(className: ParseFlaggedContentClass)
//        flagObject.setObject(user, forKey: ParseFlaggedContentFromUser)
//        flagObject.setObject(post, forKey: ParseFlaggedContentToPost)
//        
//        let ACL = PFACL(user: PFUser.currentUser()!)
//        ACL.publicReadAccess = true
//        flagObject.ACL = ACL
//        
//        //TODO: add error handling
//        flagObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
//    }
    
    
}

extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}