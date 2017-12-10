//
//  RosterTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 11/30/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class RosterTableViewCell: AnimatableTableViewCell {
    
    @IBOutlet weak var rosterCellImageView: AnimatableImageView!
    @IBOutlet weak var rosterCellEmail: AnimatableLabel!
    @IBOutlet weak var rosterCellName: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
