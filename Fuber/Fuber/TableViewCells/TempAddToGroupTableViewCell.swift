//
//  TempAddToGroupTableViewCell.swift
//  Fuber
//
//  Created by Matt Eng on 7/29/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import UIKit
import Parse

protocol TempAddToGroupTableViewCellDelegate: class {
    func cell(cell: TempAddToGroupTableViewCell, didSelectFollowUser user: PFUser)
    func cell(cell: TempAddToGroupTableViewCell, didSelectUnfollowUser user: PFUser)
}

class TempAddToGroupTableViewCell: UITableViewCell {
    let groupQuery = PFQuery(className: "Groups")
    let users = PFUser.query()!
    weak var delegate: TempAddToGroupTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var user: PFUser? {
        didSet {
//            let userN = user as! PFUser?
            nameLabel.text = user?.username
            print(user?.username)

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
        print(user)
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
