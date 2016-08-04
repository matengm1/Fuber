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
    @IBOutlet weak var requestingLabel: UILabel!
    
    var group: PFObject? {
        didSet {
            titleLabel.text = group?["Name"] as! String
//            requestingLabel.text = group?["isRequesting"] as! String
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
