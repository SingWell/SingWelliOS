//
//  ChoirNameTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/16/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ChoirNameTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureView: AnimatableImageView!
    @IBOutlet weak var nameLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
