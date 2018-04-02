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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonPressed(sender: Any?) {
        //logout:
        let alertController = UIAlertController(title: "Logout", message:
            "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes, logout", style: UIAlertActionStyle.destructive) { action in
            ApiHelper.logout()
            self.performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
