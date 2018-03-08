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
    var roster = [JSON]()
    var filteredRoster = [JSON]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getRoster()
        
        self.title = "Roster"
        
        // Setup the Search Controller
        self.setupSearchController()
    }
    
    func getRoster() {
        ApiHelper.getRoster(orgId: "16", choirId: "18") { response, error in
            if error == nil {
                self.roster = response!.arrayValue
                
                self.tableView.reloadData()
            } else {
                print(error!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
        if isFiltering() {
            return filteredRoster.count
        }
        return roster.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRosterCellReuseIdentifier, for: indexPath) as! RosterTableViewCell
        let user:JSON
        if isFiltering() {
            print("FILTERED SIZE:",filteredRoster.count)
            user = filteredRoster[indexPath.row]
        } else {
            user = roster[indexPath.row]
        }
        
        var fullName = ""
        fullName += user["first_name"].stringValue
        fullName += " "
        fullName += user["last_name"].stringValue
        
        cell.rosterCellName.text = fullName
        cell.rosterCellEmail.text = user["email"].stringValue
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        cell.rosterCellImageView.image = profileImage
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user:JSON
        if isFiltering() {
            print("FILTERED SIZE:",filteredRoster.count)
            user = filteredRoster[indexPath.row]
        } else {
            user = roster[indexPath.row]
        }
        
        let navCon = AppStoryboard.User.initialViewController() as! SideItemNavigationViewController
        let nextVc = navCon.topViewController as! UserViewController
        
        nextVc.userId = user["id"].stringValue
        
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
}

extension RosterTableViewController: UISearchResultsUpdating {
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search People"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRoster = roster.filter({( user : JSON) -> Bool in
            return user["username"].stringValue.lowercased().contains(searchText.lowercased()) ||
                user["first_name"].stringValue.lowercased().contains(searchText.lowercased()) ||
                user["last_name"].stringValue.lowercased().contains(searchText.lowercased()) ||
                user["email"].stringValue.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
