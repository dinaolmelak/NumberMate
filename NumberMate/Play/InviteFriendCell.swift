//
//  InviteFriendCell.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/23/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class InviteFriendCell: UITableViewCell {

    @IBOutlet weak var inviteFriendButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inviteFriendButton.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
