//
//  MusicLibraryTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/28/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class MusicLibraryTableViewCell: AnimatableTableViewCell {
    @IBOutlet weak var songNameLabel: AnimatableLabel!
    
    @IBOutlet weak var composerNameLabel: AnimatableLabel!
    
    @IBOutlet weak var instrumentationLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
