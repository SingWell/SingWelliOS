//
//  RosterTableViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/20/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class RosterTableViewController: UITableViewController {
    
    let kRosterCellReuseIdentifier = "RosterCell"
    var rosterTest:JSON = []

    var roster:[JSON] = [
        ["id": 1, "name":"Jane Doe", "email":"test1@gmail.com"],
        ["id": 2, "name":"Susan B. Anthony", "email":"test2@gmail.com"],
        ["id": 3, "name":"Zachary Johnson", "email":"test3@gmail.com"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getRoster()
        
        self.title = "Roster"
    }
    
    func getRoster() {
        ApiHelper.getRoster(orgId: "16", choirId: "1") { response, error in
            if error == nil {
                self.rosterTest = response!
                
                self.reloadView()
            } else {
                print(error!)
            }
        }
    }
    
    func reloadView() {
//        var profileName = ""
//        if(self.user != []){
//            profileName = self.user["username"].stringValue
//        }
//
//        profileNameLabel.text = profileName
        
        print(self.rosterTest)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80.0
        default:
            return 80.0
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roster.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kRosterCellReuseIdentifier, for: indexPath) as! RosterTableViewCell
        cell.rosterCellName?.text = roster[indexPath.row]["name"].stringValue
        cell.rosterCellEmail?.text = roster[indexPath.row]["email"].stringValue
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        cell.rosterCellImageView.image = profileImage
        
        return cell
    
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
