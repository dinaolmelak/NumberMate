//
//  PlayCell.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/23/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class PlayCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playButton.layer.cornerRadius = 20
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
