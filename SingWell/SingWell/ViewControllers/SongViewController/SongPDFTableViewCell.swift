//
//  SongPDFTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 2/22/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class SongPDFTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var pdfNameLabel: AnimatableLabel!
    @IBOutlet weak var openPDFLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
