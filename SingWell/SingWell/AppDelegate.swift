//
//  AppDelegate.swift
//  SingWell
//
//  Created by Travis Siems on 10/29/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit

let kToken = "AUTH_TOKEN"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: check if this token is valid
        if let token = UserDefaults.standard.value(forKey: kToken) as? String {
            // Token stored in NSUserDefaults.
            print("USER already logged in")
            ApiHelper.AUTH_TOKEN = token
        } else {
            // Have to login
            ApiHelper.login( "kenton", "password123") { response, error in
                if error == nil {
                    print("LOGGED IN")
                    ApiHelper.AUTH_TOKEN = response!["token"].stringValue
                    
                    // save value in user defaults
                    UserDefaults.standard.setValue(ApiHelper.AUTH_TOKEN, forKey: kToken)
                    UserDefaults.standard.synchronize()
                } else {
                    print("ERROR Logging in:",error as Any)
                }
            }
        }
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

