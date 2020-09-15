//
//  GuessCell.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/5/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class GuessCell: UITableViewCell {
    @IBOutlet weak var guess: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var group: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
