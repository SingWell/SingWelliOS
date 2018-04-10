//
//  EventInfoTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 3/8/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class EventInfoTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var eventTimeLabel: AnimatableLabel!
    @IBOutlet weak var eventDateLabel: AnimatableLabel!
    @IBOutlet weak var eventLocationLabel: AnimatableLabel!
    @IBOutlet weak var eventNameLabel: AnimatableLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
