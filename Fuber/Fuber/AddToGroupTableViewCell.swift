//
//  AddToGroupTableViewCell.swift
//  Fuber
//
//  Created by Matt Eng on 7/18/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import UIKit
import Parse

protocol AddToGroupTableViewCellDelegate: class {
    func cell(cell: AddToGroupTableViewCell, didSelectFollowUser user: PFObject)
    func cell(cell: AddToGroupTableViewCell, didSelectUnfollowUser user: PFObject)
}

class AddToGroupTableViewCell: UITableViewCell {
    
    let groupQuery = PFQuery(className: "Groups")
    weak var delegate: AddToGroupTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var user: PFUser? {
        didSet {
            nameLabel.text = user?.username
//            nameLabel.text = "NAME SET"
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            /*
             Change the state of the follow button based on whether or not
             it is possible to follow a user.
             */
            if let canFollow = canFollow {
                addButton.selected = !canFollow
            }
        }
    }
    
    @IBAction func AddButtonTouched(sender: AnyObject) {
//        if let canFollow = canFollow where canFollow == true {
////            delegate?.cell(self, didSelectFollowUser: user!)
//            delegate?.cell(self, didSelectFollowUser: PFUser.currentUser()!)
//            addButton.setTitle("Added", forState: .Selected)
//
//            self.canFollow = false
//        } else {
////            delegate?.cell(self, didSelectUnfollowUser: user!)
//            print(PFUser.currentUser()!)
//            delegate?.cell(self, didSelectUnfollowUser: PFUser.currentUser()!)
//            self.canFollow = true
//            addButton.setTitle("Add to Group", forState: .Normal)
//        }
////        print(canFollow)
        if let canFollow = canFollow where canFollow == true {
            delegate?.cell(self, didSelectFollowUser: user!)
            self.canFollow = false
            print("Follow button tapped")
        } else {
            delegate?.cell(self, didSelectUnfollowUser: user!)
            self.canFollow = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
