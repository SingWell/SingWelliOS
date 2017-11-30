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
    
    case Profile, EditProfile, Choir, SideMenu, Notifications, Calendar, Roster, SettingsModal
    
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

// hex colors and lighter/darker colors
extension UIColor {
    
    func lighterColor(percentage:CGFloat=1.3,withSaturation:CGFloat=1.0) -> UIColor
    {
        var h:CGFloat = 0.0
        var s:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor.init(hue: h, saturation: min(s * withSaturation,1.0), brightness: min(b * percentage,1.0), alpha: a)
        }
        return self
    }
    
    func darkerColor() -> UIColor
    {
        var h:CGFloat = 0.0
        var s:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor.init(hue: h, saturation: s, brightness: b * 0.75, alpha: a)
        }
        return self
    }
}
