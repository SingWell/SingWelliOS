//
//  SongTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 2/14/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class SongInfoTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var songNameLabel: AnimatableLabel!
    
    @IBOutlet weak var practiceButton: AnimatableButton!
    
    @IBOutlet weak var composerNameLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
