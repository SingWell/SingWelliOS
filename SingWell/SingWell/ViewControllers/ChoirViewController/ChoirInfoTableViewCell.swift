//
//  ChoirInfoTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/20/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ChoirInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var rosterButton: AnimatableButton!
    @IBOutlet weak var calendarButton: AnimatableButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
