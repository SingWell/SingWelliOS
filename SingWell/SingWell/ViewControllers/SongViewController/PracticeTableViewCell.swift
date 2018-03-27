//
//  PracticeTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 3/22/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class PracticeTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var mxlNameLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
