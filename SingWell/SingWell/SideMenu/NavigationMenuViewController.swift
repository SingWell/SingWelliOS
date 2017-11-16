//
//  NavigationMenuViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/9/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import IBAnimatable
import SwiftyJSON

class NavigationMenuViewController: MenuViewController {

    let kChoirCellReuseIdentifier = "ChoirNameCell"
    
    var choirs:[JSON] = []
//    var menuItems = ["Profile", "Choir A"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshChoirs()

        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshChoirs() {
        guard self.menuContainerViewController != nil else {
            return
        }
        
        ApiHelper.getOrganizations() { response, error in
            if error == nil {
                print(response!)
                self.choirs = []
                var contentViews = [["Profile"],[]]
                
                for organization in (response?.arrayValue)! {
                    // get choirs for each organization
                    ApiHelper.getChoirs(orgId: organization["id"].stringValue) { response, error in
                        if error == nil {
                            let responseChoirs = (response?.arrayValue)!
                            for choir in responseChoirs {
                                self.choirs.append(choir)
                                contentViews[1].append("Choir")
                            }
                            (self.menuContainerViewController as! HostViewController).setControllerIdentifiers(identifiers: contentViews)
                            print(self.choirs)
                            
                            self.tableView.reloadData()
                        } else {
                            print(error!)
                        }
                    }
                    
                }
            } else {
                print(error!)
            }
        }
    }
    
}

class SideItemNavigationViewController: AnimatableNavigationController, SideMenuItemContent {
    override func viewWillAppear(_ animated: Bool) {
        if FIRST_CONTROLLER == true {
            self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
            FIRST_CONTROLLER = false
        } else {
            self.additionalSafeAreaInsets = UIEdgeInsetsMake(20,0,0,0)
        }
    }
}


/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return choirs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: kChoirCellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = "Profile"
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: kChoirCellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = self.choirs[indexPath.row]["name"].stringValue
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        // determine the index of the selected
        var index = 0
        
        // count the number of rows in each section before this one
        var i = 0
        let identifiers = (menuContainerViewController as! HostViewController).controllerIdentifiers
        while i < indexPath.section {
            index += identifiers[i].count
            i += 1
        }
        
        // add the number of rows
        index += indexPath.row
        
        switch indexPath.section {
        case 0:
            let nextVc = menuContainerViewController.contentViewControllers[index]
            
            menuContainerViewController.selectContentViewController(nextVc)
        default:
            // Selected a choir:
            let nextVc = menuContainerViewController.contentViewControllers[index] as! SideItemNavigationViewController
            (nextVc.childViewControllers.first as! ChoirTableViewController).choirInfo = self.choirs[indexPath.row]
            
            menuContainerViewController.selectContentViewController(nextVc)
        }
        
        menuContainerViewController.hideSideMenu()
    }
}
