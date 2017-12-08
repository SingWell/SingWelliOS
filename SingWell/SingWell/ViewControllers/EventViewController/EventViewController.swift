//
//  EventViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/28/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import SwiftyJSON
import IBAnimatable

class EventViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: AnimatableLabel!
    @IBOutlet weak var dateLabel: AnimatableLabel!
    @IBOutlet weak var timeLabel: AnimatableLabel!
    
    var eventInfo:JSON = [
        "id": 1,
        "name": "Event Name",
        "date": "2017-11-26",
        "time": "23:00:00",
        "location": "Chapel",
        "choirs": [
            1,
            3
        ],
        "organization": 1
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = eventInfo["name"].stringValue
        self.locationLabel.text = eventInfo["location"].stringValue
        
        print(eventInfo)
        setupDateTimeLabels()
    }
    
    func setupDateTimeLabels() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        
        formatter.dateFormat = "yyyy-MM-dd"
        let eventDate = formatter.date(from: eventInfo["date"].stringValue)
        
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        self.dateLabel.text = formatter.string(from: eventDate!)
        
        formatter.dateFormat = "hh:mm:ss"
        let eventTime = formatter.date(from: eventInfo["time"].stringValue)
        
        formatter.dateFormat = "h:mm a"
        self.timeLabel.text = formatter.string(from: eventTime!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
