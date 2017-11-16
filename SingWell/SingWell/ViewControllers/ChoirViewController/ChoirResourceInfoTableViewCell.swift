//
//  ChoirResourceInfoTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/14/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ChoirResourceInfoTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var titleLabel: AnimatableLabel!
    @IBOutlet weak var descriptionField: AnimatableTextView!
    @IBOutlet weak var timeLabel: AnimatableLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionField.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
