//
//  ChoirTableViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/9/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import IBAnimatable
import IoniconsKit
import SwiftyJSON

class ChoirTableViewController: UITableViewController {
    
    @IBOutlet weak var rightBarButtonItem: AnimatableBarButtonItem!
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")
    
    var choirInfo:JSON = ["name":"Choir A"]

//    var choirUpdatesList:JSON = [
//        ["title":"Event Changed", "info":"The time for mass changed to 12:00pm-1:30pm.", "time":"1 hour ago"],
//        ["title":"New Event Added", "info":"There will be a mass on Sunday, November 22 from 10:30am-12:00pm.", "time":"2 days ago"]
//    ]
    
    var choirUpdatesList:JSON = [
        [
            "id": 1,
            "name": "11/26 Mass",
            "date": "2017-11-26",
            "time": "23:00:00",
            "location": "Chapel",
            "choirs": [
                1,
                3
            ],
                "organization": 1
        ],
        [
            "id": 2,
            "name": "11/12 Mass",
            "date": "2017-11-12",
            "time": "11:30:00",
            "location": "Worship Room",
            "choirs": [
                1
            ],
            "organization": 1
        ]
    ]
    
    
    // SIDEBAR NAVIGATION
    @IBOutlet weak var menuItem: AnimatableBarButtonItem!
    
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    
    func setNavigationItems() {
        menuItem.title = ""
        menuItem.tintColor = .black
        menuItem.image = UIImage.ionicon(with: .navicon, textColor: UIColor.black, size: CGSize(width: 32, height: 32))
    }
    
    
    func setRightNavItem() {
        rightBarButtonItem.title = ""
        rightBarButtonItem.tintColor = .black
        rightBarButtonItem.image = UIImage.ionicon(with: .iosBell, textColor: UIColor.black, size: CGSize(width: 32, height: 32))

        // TODO: show a number label with the number of unread notifications
    }
    
    @IBAction func viewNotifications(_ sender: Any) {
        let nextVc = AppStoryboard.Notifications.initialViewController() as! NotificationsTableViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewCalendar(_ sender: Any) {
        let nextVc = AppStoryboard.Calendar.initialViewController() as! CalendarViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewRoster(_ sender: Any) {
        let nextVc = AppStoryboard.Roster.initialViewController() as! RosterTableViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewMusicLibrary(_ sender: Any) {
        let nextVc = AppStoryboard.MusicLibrary.initialViewController() as! MusicLibraryTableViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = choirInfo["name"].stringValue
        
        self.tableView.backgroundColor = BACKGROUND_COLOR
        
        setNavigationItems()
        setRightNavItem()
        
        self.view.frame = self.view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // choir info cell
            return 1
        default:
            return choirUpdatesList.arrayValue.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 147.0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // choir info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoirInfoCell", for: indexPath) as! ChoirInfoTableViewCell
            
            cell.contentView.backgroundColor = BACKGROUND_COLOR

            // CALENDAR BUTTON
            cell.calendarButton.addTarget(self, action: #selector(ChoirTableViewController.viewCalendar(_:)), for: UIControlEvents.touchUpInside)
            cell.calendarButton.titleLabel?.font = UIFont.ionicon(of: 30)
            cell.calendarButton.setTitle(String.ionicon(with:.calendar), for: .normal)
            
            // ROSTER BUTTON
            cell.rosterButton.addTarget(self, action: #selector(ChoirTableViewController.viewRoster(_:)), for: UIControlEvents.touchUpInside)
            cell.rosterButton.titleLabel?.font = UIFont.ionicon(of: 30)
            cell.rosterButton.setTitle(String.ionicon(with:.iosPeople), for: .normal)
            
            // MUSIC LIBRARY BUTTON
            cell.musicLibraryButton.addTarget(self, action: #selector(ChoirTableViewController.viewMusicLibrary(_:)), for: UIControlEvents.touchUpInside)
            cell.musicLibraryButton.titleLabel?.font = UIFont.ionicon(of: 30)
            cell.musicLibraryButton.setTitle(String.ionicon(with:.musicNote), for: .normal)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicUpdateCell", for: indexPath) as! ChoirResourceInfoTableViewCell
            let info = choirUpdatesList[indexPath.row]
            
            cell.titleLabel.text = info["name"].stringValue
            cell.descriptionField.text = info["location"].stringValue
            cell.descriptionField.isUserInteractionEnabled = false
//            [
//                {
//                    "id": 1,
//                    "name": "11/26 Mass",
//                    "date": "2017-11-26",
//                    "time": "23:00:00",
//                    "location": "Chapel",
//                    "choirs": [
//                    1,
//                    3
//                    ],
//                    "organization": 1
            cell.contentView.backgroundColor = BACKGROUND_COLOR
            return cell
        }
        
    }
    
    func viewEvent(row:Int) {
        let nextVc = AppStoryboard.Event.initialViewController() as! EventViewController
        nextVc.eventInfo = choirUpdatesList[row]
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            print("Do nothing!")
        default:
            print(indexPath.row)
//            let cell = tableView.cellForRow(at: indexPath) as! ChoirResourceInfoTableViewCell
//            cell.cardView.animate(.pop(repeatCount: 1), duration: 0.3)
//            cell.cardView.animate(.shake(repeatCount: 1), duration: 0.5)
            viewEvent(row: indexPath.row)
        }
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
