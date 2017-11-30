//
//  MusicLibraryTableViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/28/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import SwiftyJSON

class MusicLibraryTableViewController: UITableViewController {
    
    var filteredMusicLibrary = [JSON]()

    var musicLibrary:[JSON] = [
        [
            "name":"Prelude",
            "composer":"J.S. Bach",
            "parts":"SATB"
        ],
        [
            "name":"Song 2",
            "composer":"J.S. Bach",
            "parts":"SATB"
        ],
        [
            "name":"My Favorite Things",
            "composer":"John Coltrane",
            "parts":"SATB"
        ]
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SONG:",musicLibrary[0].stringValue)
        
        self.title = "Music Library"
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Music"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMusicLibrary.count
        }
        return musicLibrary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songInfoCell", for: indexPath) as! MusicLibraryTableViewCell
        let song:JSON
        if isFiltering() {
            song = filteredMusicLibrary[indexPath.row]
        } else {
            song = musicLibrary[indexPath.row]
        }
        
        cell.songNameLabel.text = song["name"].stringValue
        cell.composerNameLabel.text = song["composer"].stringValue
        cell.partsLabel.text = song["parts"].stringValue
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMusicLibrary = musicLibrary.filter({( song : JSON) -> Bool in
            return song["name"].stringValue.lowercased().contains(searchText.lowercased()) ||
                song["composer"].stringValue.lowercased().contains(searchText.lowercased()) ||
                song["parts"].stringValue.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    


}

extension MusicLibraryTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
