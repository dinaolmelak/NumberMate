//
//  MoneyCell.swift
//  NumberMate
//
//  Created by Dinaol Melak on 10/16/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class MoneyCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
