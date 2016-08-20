//
//  GroupTableViewCell.swift
//  Fuber
//
//  Created by Matt Eng on 7/18/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import UIKit
import Parse

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var requestingLabel: UILabel!
    
    var group: PFObject? {
        didSet {
            print(group)
            let requestUser = group?["requestFromUser"]
            var requestingUser : PFUser?
            if requestUser != nil {
                requestingUser = requestUser as? PFUser
            }
            titleLabel.text = group?["Name"] as? String
            if group?["isRequesting"] as! Bool && requestingUser != nil {
//                print(requestUser, "Woop")
                nameLabel.text = requestingUser!.username
                requestingLabel.text = "Requesting Pickup"
            } else {
                nameLabel.text = ""
                requestingLabel.text = "No Request"
            }
            requestingLabel.text = group?["isRequesting"] as? String
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
