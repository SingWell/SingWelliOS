//
//  ProfileTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/16/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ProfileTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var nameLabel: AnimatableLabel!
    @IBOutlet weak var pictureView: AnimatableImageView!
    
    var cellColor = UIColor.init(hexString: "#1BA0FC")
    var highlightedColor = UIColor.init(hexString: "#1BA0FC").darkerColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        self.backgroundColor = cellColor
        
        if selected {
            self.backgroundColor = UIColor.init(hexString: "cccccc")
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = self.highlightedColor
            })
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.backgroundColor = highlightedColor
        } else {
            self.backgroundColor = cellColor
        }
    }

}
