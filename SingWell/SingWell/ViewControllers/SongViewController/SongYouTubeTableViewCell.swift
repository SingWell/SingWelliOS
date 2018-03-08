//
//  SongResourceTableViewCell.swift
//  SingWell
//
//  Created by Elena Sharp on 2/19/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class SongYouTubeTableViewCell: AnimatableTableViewCell {
    
    @IBOutlet weak var wv: UIWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
