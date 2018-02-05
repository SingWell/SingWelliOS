//
//  ChoirInfoTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/20/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ChoirInfoTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var directedByLabel: AnimatableLabel!
    @IBOutlet weak var directorNameButton: AnimatableButton!
    @IBOutlet weak var descriptionLabel: AnimatableLabel!
    @IBOutlet weak var musicLibraryButton: AnimatableButton!
    @IBOutlet weak var rosterButton: AnimatableButton!
    @IBOutlet weak var calendarButton: AnimatableButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
