//
//  Extensions.swift
//  SingWell
//
//  Created by Travis Siems on 10/29/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Child, Profile, Choir, SideMenu
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard : AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
