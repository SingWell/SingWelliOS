//
//  EventViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/28/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventViewController: UIViewController {

    var eventInfo:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event Name"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
