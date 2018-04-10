//
//  Extensions.swift
//  SingWell
//
//  Created by Travis Siems on 10/29/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum AppStoryboard : String {
    
    case Profile, EditProfile, Choir, SideMenu, Notifications, Calendar, Roster, MusicLibrary, Event, Song, SettingsModal, NewEditProfile, Login, Register, Practice, PracticeSettings, User
    
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

var CURRENT_CHOIR_ID = 0

extension JSON {
    static let formatter = DateFormatter()
    static let kDate = "date"
    static let kTime = "time"
    
    static let ascendingDateStrings: (JSON, JSON) -> Bool = {
        if $0[kDate].stringValue != $1[kDate].stringValue {
            return $0[kDate].stringValue < $1[kDate].stringValue
        } else {
            return $0[kTime].stringValue < $1[kTime].stringValue
        }
    }
    
    static let descendingDateStrings: (JSON, JSON) -> Bool = {
        if $0[kDate].stringValue != $1[kDate].stringValue {
            return $0[kDate].stringValue > $1[kDate].stringValue
        } else {
            return $0[kTime].stringValue > $1[kTime].stringValue
        }
    }
    
    static let pastDateStrings: (JSON) -> Bool = {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        return $0[kDate].stringValue < formatter.string(from: Date())
    }
    
    static let futureDateStrings: (JSON) -> Bool = {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        return $0[kDate].stringValue >= formatter.string(from: Date())
    }
    
    static let currentChoirId: (JSON) -> Bool = {
        return $0["choirs"].arrayValue.map{ $0.intValue }.contains(CURRENT_CHOIR_ID)
    }
}


class TableViewHelper {
    
    class func EmptyMessage(message:String, viewController:UITableViewController) {
        let messageLabel = UILabel(frame: CGRect.init(x: 8, y: 0, width: viewController.view.bounds.size.width-16, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
    }
}
