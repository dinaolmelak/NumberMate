//
//  GetPointCell.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/23/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class GetPointCell: UITableViewCell {

    @IBOutlet weak var getPointsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getPointsButton.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
