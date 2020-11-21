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
    @IBOutlet weak var inputGuess: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guess.alpha = 0.0
        order.alpha = 0.0
        group.alpha = 0.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
