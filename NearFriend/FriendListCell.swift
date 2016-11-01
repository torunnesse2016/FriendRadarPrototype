//
//  FriendListCell.swift
//  NearFriend
//
//  Created by MobileDev on 10/31/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var btnadd: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
