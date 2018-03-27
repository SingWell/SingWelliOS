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
    
    var orgId = "1"
    
    var filteredMusicLibrary = [JSON]()

    var musicLibrary:[JSON] = [
//        [
//            "title":"Prelude",
//            "composer":"J.S. Bach",
//            "instrumentation":"SATB"
//        ],
//        [
//            "title":"Song 2",
//            "composer":"J.S. Bach",
//            "instrumentation":"SATB"
//        ],
//        [
//            "title":"My Favorite Things",
//            "composer":"John Coltrane",
//            "instrumentation":"SATB"
//        ]
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("SONG:",musicLibrary[0].stringValue)
        
        self.getMusicLibrary()
        
        self.title = "Music Library"
        
        // Setup the Search Controller
        self.setupSearchController()
    }
    
    func getMusicLibrary() {
        ApiHelper.getMusicRecords(orgId: self.orgId) { response, error in
            if error == nil {
                self.musicLibrary = response!.arrayValue
                self.tableView.reloadData()
            } else {
                print("Error getting musicRecords: ",error as Any)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if musicLibrary.count > 0 {
            return 1
        } else {
            TableViewHelper.EmptyMessage(message: "This organization does not have any public music records yet.\n", viewController: self)
            return 0
        }
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
        
        cell.songNameLabel.text = song["title"].stringValue
        cell.composerNameLabel.text = song["composer"].stringValue
        cell.instrumentationLabel.text = song["instrumentation"].stringValue
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songInfo: JSON
        if isFiltering() {
            songInfo = filteredMusicLibrary[indexPath.row]
        } else {
            songInfo = musicLibrary[indexPath.row]
        }
        
        let nextVc = AppStoryboard.Song.initialViewController() as! SongTableViewController
        nextVc.songInfo = songInfo
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}

extension MusicLibraryTableViewController: UISearchResultsUpdating {
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Music"
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
        filteredMusicLibrary = musicLibrary.filter({( song : JSON) -> Bool in
            return song["title"].stringValue.lowercased().contains(searchText.lowercased()) ||
                song["composer"].stringValue.lowercased().contains(searchText.lowercased()) ||
                song["instrumentation"].stringValue.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
