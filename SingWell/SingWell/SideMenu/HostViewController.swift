//
//  HostViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/9/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class HostViewController: MenuContainerViewController {

    var controllerIdentifiers = [["Profile","Choir"]]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func loadUserInfo() {
        (self.menuViewController as! NavigationMenuViewController).refreshChoirs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
        
        // Instantiate menu view controller by identifier
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
        
        loadUserInfo()
        
        // Gather content items controllers
        self.contentViewControllers = contentControllers()
        
        // Select initial content controller. It's needed even if the first view controller should be selected.
        let firstVc = contentViewControllers.first!
        self.selectContentViewController(firstVc)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        /*
         Options to customize menu transition animation.
         */
        var options = TransitionOptions()
        
        // Animation duration
        options.duration = size.width < size.height ? 0.4 : 0.6
        
        // Part of item content remaining visible on right when menu is shown
        options.visibleContentWidth = size.width / 6
        self.transitionOptions = options
    }
    
    func setControllerIdentifiers(identifiers:[[String]]) {
        controllerIdentifiers = identifiers
        self.contentViewControllers = contentControllers()
        
        print("IDENTIFIERS: ",controllerIdentifiers)
    }
    
    private func contentControllers() -> [UIViewController] {
        var contentList = [UIViewController]()
        
        /*
         Instantiate items controllers from storyboard.
         */
        for section in controllerIdentifiers {
            for identifier in section {
                if let viewController = AppStoryboard(rawValue: identifier)?.initialViewController() {
                    contentList.append(viewController)
                }
            }
        }
        
        return contentList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
