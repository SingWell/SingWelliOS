//
//  SongViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/29/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import SwiftyJSON
import IBAnimatable

class SongViewController: UIViewController {
    
    var songInfo:JSON = [
        "name":"My Favorite Things",
        "composer":"John Coltrane",
        "instrumentation":"SATB"
    ]
    
    @IBOutlet weak var nameLabel: AnimatableLabel!
    @IBOutlet weak var composerLabel: AnimatableLabel!
    @IBOutlet weak var instrumentationLabel: AnimatableLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = songInfo["name"].stringValue
        
        nameLabel.text = songInfo["name"].stringValue
        composerLabel.text = songInfo["composer"].stringValue
        instrumentationLabel.text = songInfo["instrumentation"].stringValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
