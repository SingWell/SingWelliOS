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
    
    @IBOutlet weak var instrumentationLabel: AnimatableLabel!
    @IBOutlet weak var composerNameLabel: AnimatableLabel!
    @IBOutlet weak var arrangerNameLabel: AnimatableLabel!
    @IBOutlet weak var publisherNameLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
