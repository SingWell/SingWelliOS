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

let kChoirInfo = "Choir Info"
let kUpcomingEvents = "Upcoming Events"
let kPastEvents = "Past Events"

class ChoirTableViewController: UITableViewController {

    
    let SECTIONS:[String] = [kChoirInfo, kUpcomingEvents, kPastEvents]
    
    @IBOutlet weak var rightBarButtonItem: AnimatableBarButtonItem!
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")
    
    let INFO_COLOR = UIColor.init(hexString: "2fd0b0")
    
    let formatter = DateFormatter()
    
    var choirInfo:JSON = ["name":"Choir A"]
    
    var rosterImages: [UIImage] = []

//    var choirUpdatesList:JSON = [
//        ["title":"Event Changed", "info":"The time for mass changed to 12:00pm-1:30pm.", "time":"1 hour ago"],
//        ["title":"New Event Added", "info":"There will be a mass on Sunday, November 22 from 10:30am-12:00pm.", "time":"2 days ago"]
//    ]
    
    var upcomingChoirEvents:[JSON] = []
    var pastChoirEvents:[JSON] = []
    
    
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
        
        // Hide for now
        rightBarButtonItem.isEnabled = false
        rightBarButtonItem.tintColor = UIColor.clear
        // TODO: show a number label with the number of unread notifications
    }
    
    @IBAction func viewDirectorProfile(_ sender: Any) {
        
        let navCon = AppStoryboard.User.initialViewController() as! SideItemNavigationViewController
        let nextVc = navCon.topViewController as! UserViewController
        
        nextVc.userId = choirInfo["director"].stringValue
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewNotifications(_ sender: Any) {
        let nextVc = AppStoryboard.Notifications.initialViewController() as! NotificationsTableViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewCalendar(_ sender: Any) {
        let nextVc = AppStoryboard.Calendar.initialViewController() as! CalendarViewController
        nextVc.orgId = choirInfo["organization"].stringValue
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewRoster(_ sender: Any) {
        let nextVc = AppStoryboard.Roster.initialViewController() as! RosterTableViewController
        nextVc.choirId = choirInfo["id"].stringValue
        nextVc.orgId = choirInfo["organization"].stringValue
        nextVc.rosterImages = rosterImages
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func viewMusicLibrary(_ sender: Any) {
        let nextVc = AppStoryboard.MusicLibrary.initialViewController() as! MusicLibraryTableViewController
        nextVc.orgId = choirInfo["organization"].stringValue
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.timeZone = .current
        formatter.locale = .current
        
        self.title = "Choir"
        
        self.tableView.backgroundColor = BACKGROUND_COLOR
        
        setNavigationItems()
        setRightNavItem()
        getChoirEvents()
//        getRosterImages()
        
        self.view.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CURRENT_CHOIR_ID = self.choirInfo["id"].intValue
    }
    
    func getChoirEvents() {
        ApiHelper.getEvents(orgId: choirInfo["organization"].stringValue) { response, error in
            
            if error == nil {
                
                var events = response!.arrayValue
                print(events)
                CURRENT_CHOIR_ID = self.choirInfo["id"].intValue
                events = events.filter( JSON.currentChoirId )
                self.upcomingChoirEvents = events.filter( JSON.futureDateStrings )
                self.pastChoirEvents = events.filter( JSON.pastDateStrings )

                self.upcomingChoirEvents = self.upcomingChoirEvents.sorted(by: JSON.ascendingDateStrings )
                self.pastChoirEvents = self.pastChoirEvents.sorted(by: JSON.descendingDateStrings )
                
                self.tableView.reloadData()
            } else {
                print("Error getting events: ",error as Any)
            }
        }
    }
    
    func getRosterImages() {
        for index in 0 ... (self.choirInfo["choristers"].count - 1) {
            ApiHelper.getPicture(path: "pictures", id: self.choirInfo["choristers"][index].stringValue, type: "profile") { data, error in
                if error == nil {
                    var decodedimage:UIImage
                    let convertedData = Data(base64Encoded: data!)
                    if(convertedData != nil){
                        decodedimage = UIImage(data: convertedData!)!
                    }
                    else {
                        decodedimage = UIImage(named: "profileImage")!
                    }
                    decodedimage = decodedimage.circleMasked!
                    var profileImage = decodedimage
                    self.rosterImages.append(profileImage)
                } else {
                    print("Error getting profilePic: ",error as Any)
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SECTIONS[section] {
        case kChoirInfo: // choir info cell
            return 1
        case kUpcomingEvents:
            return min(upcomingChoirEvents.count, 4)
        case kPastEvents:
            return min(pastChoirEvents.count, 4)
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SECTIONS[indexPath.section] {
        case kChoirInfo:
            return 167.0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SECTIONS[indexPath.section] {
        case kChoirInfo: // choir info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoirInfoCell", for: indexPath) as! ChoirInfoTableViewCell
            
            cell.contentView.backgroundColor = BACKGROUND_COLOR
            
            // CHOIR NAME LABEL
            cell.choirNameLabel.text = choirInfo["name"].stringValue
            
            //DIRECTOR NAME BUTTON
            cell.directorNameButton.addTarget(self, action: #selector(ChoirTableViewController.viewDirectorProfile(_:)), for: UIControlEvents.touchUpInside)
            cell.directorNameButton.setTitle(choirInfo["director_name"].stringValue, for: .normal)
            print(choirInfo)

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
            
            cell.directedByLabel.font = UIFont(name:DEFAULT_FONT, size:19)
            cell.descriptionLabel.font = UIFont(name:DEFAULT_FONT, size:19)
            cell.directorNameButton.titleLabel?.font = UIFont(name:DEFAULT_FONT, size:19)
            
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingEventCell", for: indexPath) as! EventCell
            let event = indexPath.section == 1 ? upcomingChoirEvents[indexPath.row] : pastChoirEvents[indexPath.row]
            
            cell.eventNameLabel.text = event["name"].stringValue
            cell.locationLabel.text = event["location"].stringValue
            
            cell.eventNameLabel.font = UIFont(name:DEFAULT_FONT_BOLD, size:21)
            cell.locationLabel.font = UIFont(name:DEFAULT_FONT, size:16)
            cell.dateLabel.font = UIFont(name:DEFAULT_FONT, size:29)
            cell.timeLabel.font = UIFont(name:DEFAULT_FONT, size:16)
            
            
            formatter.dateFormat = "yyyy-MM-dd"
            if let eventDate = formatter.date(from: event[JSON.kDate].stringValue) {
                formatter.dateFormat = "d"
                cell.dateLabel.text = formatter.string(from: eventDate)
                
                cell.dateLabel.textColor = CALENDAR_BACKGROUND_COLOR
                
                formatter.dateFormat = "MMM"
                cell.timeLabel.text = formatter.string(from: eventDate)
            }
            
            formatter.dateFormat = "HH:mm:ss"
            if let eventTime = formatter.date(from: event[JSON.kTime].stringValue) {
                formatter.dateFormat = "h:mm a"
                cell.eventNameLabel.text = cell.eventNameLabel.text! + " at " + formatter.string(from: eventTime)
            }
            
            cell.autoRun = true
            
            // animate
            let delay = Double(indexPath.row) * 0.5
            cell.animate(.slide(way: .in, direction: .left)).delay( delay )
            
            return cell
        }
        
    }
    
    func viewEvent(indexPath:IndexPath) {
        let nextVc = AppStoryboard.Event.initialViewController() as! EventTableViewController
        nextVc.eventInfo = indexPath.section == 1 ? upcomingChoirEvents[indexPath.row] : pastChoirEvents[indexPath.row]
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch SECTIONS[indexPath.section] {
        case kChoirInfo:
            print("Do nothing!")
        default:
            print(indexPath.row)
//            let cell = tableView.cellForRow(at: indexPath) as! ChoirResourceInfoTableViewCell
//            cell.cardView.animate(.pop(repeatCount: 1), duration: 0.3)
//            cell.cardView.animate(.shake(repeatCount: 1), duration: 0.5)
            viewEvent(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch SECTIONS[section] {
        case kChoirInfo:
            return ""
        case kUpcomingEvents:
            return kUpcomingEvents
        case kPastEvents:
            return kPastEvents
        default:
            return ""
        }
    }

}
