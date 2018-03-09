//
//  ProgramTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 3/8/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ProgramTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var NotesLabel: AnimatableLabel!
    @IBOutlet weak var songTitleLabel: AnimatableLabel!
    @IBOutlet weak var composerLabel: AnimatableLabel!
    @IBOutlet weak var fieldTitleLabel: AnimatableLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
