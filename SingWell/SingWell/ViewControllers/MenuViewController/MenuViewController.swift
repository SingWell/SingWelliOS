//
//  MenuViewController.swift
//  SingWell
//
//  Created by Travis Siems on 10/29/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        goToChildView()
    }
    
    func goToChildView() {
        let nextViewController = AppStoryboard.Child.initialViewController()!
//        self.present(nextViewController, animated: true, completion: nil)
    self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
