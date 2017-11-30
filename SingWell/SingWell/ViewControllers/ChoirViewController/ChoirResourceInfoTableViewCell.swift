//
//  ChoirResourceInfoTableViewCell.swift
//  SingWell
//
//  Created by Travis Siems on 11/14/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

class ChoirResourceInfoTableViewCell: AnimatableTableViewCell {

    @IBOutlet weak var cardView: AnimatableView!
    @IBOutlet weak var titleLabel: AnimatableLabel!
    @IBOutlet weak var descriptionField: AnimatableTextView!
    @IBOutlet weak var timeLabel: AnimatableLabel!
    
    var cellColor = UIColor.init(hexString: "#E4F2FD")
    var highlightedColor = UIColor.init(hexString: "#BCDFFA")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionField.isEditable = false
        descriptionField.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        self.cardView.fillColor = cellColor
        
        if selected {
            self.cardView.fillColor = UIColor.init(hexString: "cccccc")
            UIView.animate(withDuration: 0.2, animations: {
                self.cardView.fillColor = self.highlightedColor
            })
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.cardView.fillColor = highlightedColor
        } else {
            self.cardView.fillColor = cellColor
        }
    }
    
    

}
