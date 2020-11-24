//
//  PlayerInfoCell.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/22/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class PlayerInfoCell: UITableViewCell {

    @IBOutlet weak var winCount: UILabel!
    @IBOutlet weak var gameCount: UILabel!
    @IBOutlet weak var npointsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
