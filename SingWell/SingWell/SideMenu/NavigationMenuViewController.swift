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

class LogoutTableViewCell: AnimatableTableViewCell {
    @IBOutlet weak var logoutLabel: AnimatableLabel!
    
}

class NavigationMenuViewController: MenuViewController {

    let kProfileCellReuseIdentifier = "ProfileCell"
    let kChoirNameCellReuseIdentifier = "ChoirNameCell"
    let kLogoutCellReuseIdentifier = "LogoutCell"
    
    var username:String = "bob"
    var choirs:[JSON] = []
    var organizations:[JSON] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        refreshChoirs()

        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setOrgsForUser(orgIds:JSON) {
        self.choirs = []
        var contentViews = [["Profile"],[]]
        var numberOfChoirRequests = 0
        for orgId in orgIds.arrayValue {
            ApiHelper.getOrganization(orgId: orgId.stringValue) { organization, error in
                if error == nil {
                    self.organizations.append(organization!)
                        
                    // get choirs for each organization
                    numberOfChoirRequests += 1
                    ApiHelper.getChoirs(orgId: organization!["id"].stringValue) { response, error in
                        numberOfChoirRequests -= 1
                        
                        if error == nil {
                            let responseChoirs = (response?.arrayValue)!
                            for choir in responseChoirs {
                                self.choirs.append(choir)
                                contentViews[1].append("Choir")
                            }
                            (self.menuContainerViewController as! HostViewController).setControllerIdentifiers(identifiers: contentViews)
//                            print(self.choirs)
                            
                            if numberOfChoirRequests == 0 && self.tableView != nil {
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            print(error!)
                        }
                    }
                } else {
                    print(error!)
                }
            }
        }
//        ApiHelper.getOrganizations() { response, error in
//            if error == nil {
//                print(response!)
//                self.choirs = []
//                var contentViews = [["Profile"],[]]
//
//                for organization in (response?.arrayValue)! {
//                    self.organizations.append(organization)
//
//                    // get choirs for each organization
//                    ApiHelper.getChoirs(orgId: organization["id"].stringValue) { response, error in
//                        if error == nil {
//                            let responseChoirs = (response?.arrayValue)!
//                            for choir in responseChoirs {
//                                self.choirs.append(choir)
//                                contentViews[1].append("Choir")
//                            }
//                            (self.menuContainerViewController as! HostViewController).setControllerIdentifiers(identifiers: contentViews)
//                            print(self.choirs)
//
//                            if self.tableView != nil {
//                                self.tableView.reloadData()
//                            }
//                        } else {
//                            print(error!)
//                        }
//                    }
//
//                }
//            } else {
//                print(error!)
//            }
//        }
    }
    
    func refreshChoirs() {
        guard self.menuContainerViewController != nil else {
            return
        }
        print("USER ID RN:",ApiHelper.userId)
        ApiHelper.getUser() {
            response, error in
            if error == nil {
                self.username = response!["first_name"].stringValue + " " + response!["last_name"].stringValue
                self.setOrgsForUser(orgIds: response!["owned_organizations"])
                
            } else {
                print("ERROR GETTIN USER",error!)
            }
        }
    }
    
}

var FIRST_CONTROLLER = true

var CLASS_INSETS:[String] = []


// TODO: FIX THIS FROM BEING A HACK TO BEING A REAL FIX
class SideItemNavigationViewController: AnimatableNavigationController, SideMenuItemContent {

    override func viewWillAppear(_ animated: Bool) {
        
        let screenSize = UIScreen.main.bounds
        
        // DETERMINE IF WE NEED EXTRA SAFE AREA INSETS BASED ON PHONE MODEL
        switch screenSize.height {
        case 812.0: // iPhone X
            if FIRST_CONTROLLER == true {
                self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
                FIRST_CONTROLLER = false
            } else {
                self.additionalSafeAreaInsets = UIEdgeInsetsMake(44,0,0,0)
            }
            break
        case 667.0: // iPhone 7/8
            if FIRST_CONTROLLER == true {
                self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
                FIRST_CONTROLLER = false
            } else {
                self.additionalSafeAreaInsets = UIEdgeInsetsMake(20,0,0,0)
            }
            break
        case 736.0: // iPhone 7/8 Plus
            let profileClass = String(describing: Optional(SingWell.ProfileViewController.self))
            let choirClass = String(describing: Optional(SingWell.ChoirTableViewController.self))
            let vcClass = String(describing: self.childViewControllers.first?.classForCoder)
            if FIRST_CONTROLLER == true || !CLASS_INSETS.contains(vcClass) {
                
                self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
                print("NO SAFE AREA INSETS",vcClass)
                CLASS_INSETS.append(vcClass)
                FIRST_CONTROLLER = false
            } else {
                if vcClass == profileClass && !CLASS_INSETS.contains(choirClass) {
                    print("FIXING SAFE AREA INSETS")
                    CLASS_INSETS.append(choirClass)
                    self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
                }
                else {
                    self.additionalSafeAreaInsets = UIEdgeInsetsMake(20,0,0,0)
                    print("SAFE AREA INSETS")
                }
                
                
            }
            break
        default:
//            print("Any other phone", screenSize.height)
            self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
            break
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
        case 1:
            return choirs.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80.0
        case 1:
            return 80.0
        default:
            return 50.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: kProfileCellReuseIdentifier, for: indexPath) as! ProfileTableViewCell
            cell.nameLabel?.text = username
            
            let profileImage: UIImage = UIImage(named: "profileImage")!
            cell.pictureView.image = profileImage
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: kChoirNameCellReuseIdentifier, for: indexPath) as! ChoirNameTableViewCell
            
            let choir = self.choirs[indexPath.row]
            cell.nameLabel?.text = choir["name"].stringValue

            // get the organization that this choir is in
            cell.orgNameLabel.text = choir["organization_name"].stringValue
            
            let profileImage: UIImage = UIImage(named: "musicNotes")!
            cell.pictureView.image = profileImage
            cell.pictureView.clipsToBounds = true
            
            cell.selectionStyle = .gray
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: kLogoutCellReuseIdentifier, for: indexPath) as! LogoutTableViewCell
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
