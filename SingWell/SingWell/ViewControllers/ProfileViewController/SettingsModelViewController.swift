//
//  SettingsModelViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 11/30/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import IoniconsKit

class SettingsModelViewController: AnimatableModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonPressed(sender: Any?) {
        //logout
        ApiHelper.logout()
        self.performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
    }
    
    @IBAction func cancelButtonPressed(sender: Any?) {
        //dismiss modal
        self.dismiss(animated: true, completion: nil)
    }
}
