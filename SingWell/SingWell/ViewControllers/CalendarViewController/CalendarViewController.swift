//
//  CalendarViewController.swift
//  SingWell
//
//  Created by Travis Siems on 11/20/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import JTAppleCalendar
import IBAnimatable
import SwiftyJSON

// MARK: CALENDAR THEME VARIABLES
let CALENDAR_BACKGROUND_COLOR = UIColor(hexString: "#30BAEB")
let EVENT_SELECTED_COLOR = UIColor.white
let EVENT_SELECTED_SHADOW_COLOR = UIColor(hexString: "#444476")
//let EVENT_SELECTED_TEXT_COLOR = UIColor(hexString: "#4981BC")
let EVENT_SELECTED_TEXT_COLOR = CALENDAR_BACKGROUND_COLOR
let CALENDAR_TEXT_COLOR = UIColor.white
//UIColor(hexString: "#516AAC")
let CELL_BORDER_COLOR = UIColor.white


class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: AnimatableLabel!
    @IBOutlet weak var eventDotView: AnimatableView!
    @IBOutlet weak var selectedView: AnimatableView!
}

class EventCell: AnimatableTableViewCell {
    @IBOutlet weak var eventNameLabel: AnimatableLabel!
    
    @IBOutlet weak var timeLabel: AnimatableLabel!
    @IBOutlet weak var dateLabel: AnimatableLabel!
    @IBOutlet weak var locationLabel: AnimatableLabel!
}

class CalendarViewController: UIViewController {

    @IBOutlet weak var eventTableView: AnimatableTableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: AnimatableLabel!
    @IBOutlet weak var yearLabel: AnimatableLabel!
    
    var orgId = "1"
    var events:[JSON] = []
    
    lazy var eventDict: [Date:[JSON]] = {
        return parseEvents(events: events)
    }()
    
    lazy var selectedEvents: [JSON] = []
    
    lazy var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter
    }()
    
    let persianDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Calendar"
        
        print("Loading events:",orgId)
        getEvents()
        
        setupCalendarView()
        setupTableView()
        
        print("FIRST CALENDAR SAFEAREA INSETS",self.additionalSafeAreaInsets)
    }
    
    func getEvents() {
        ApiHelper.getEvents(orgId:self.orgId) { response, error in
            if error == nil {
                self.events = response!.arrayValue
                self.events = self.events.filter( JSON.currentChoirId )
                self.eventDict = self.parseEvents(events: self.events)
                print("EVENTS:",self.eventDict)
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                }
                
            } else {
                print("Error getting events:",error as Any)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func handleCellSelected(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CalendarCell else { return }
        if validCell.isSelected {
            validCell.selectedView.backgroundColor = EVENT_SELECTED_COLOR
            validCell.selectedView.shadowColor = EVENT_SELECTED_SHADOW_COLOR
            validCell.selectedView.isHidden = false
            validCell.selectedView.layer.zPosition = -1
            
            validCell.dateLabel.textColor = EVENT_SELECTED_TEXT_COLOR
            
            // set table view
            if let selectedDate = eventDict[cellState.date] {
                self.selectedEvents = selectedDate
            } else {
                self.selectedEvents = []
            }
            self.eventTableView.reloadData()
            
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CalendarCell else { return }
        if validCell.isSelected {
            validCell.dateLabel.textColor = UIColor.white
        } else {
            
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = CALENDAR_TEXT_COLOR
            } else { //i.e. case it belongs to inDate or outDate
                validCell.dateLabel.textColor = UIColor.gray
            }
            
        }
    }
    
    func handleCellEvents(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        validCell.eventDotView.isHidden = eventDict[cellState.date] == nil
    }
    
    func handleCellDisplay(cell: JTAppleCell?, cellState: CellState){
        cell?.layer.borderColor = CELL_BORDER_COLOR.cgColor
        cell?.layer.borderWidth = 0.5
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
    
    func setupTableView() {
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
    }
    
    func setupCalendarView(){
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup Labels
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first?.date
            
            self.formatter.dateFormat = "yyyy"
            self.yearLabel.text = self.formatter.string(from: date!)
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date!)
        }
        
        calendarView.scrollToDate( Date(), animateScroll: false)
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.selectDates( [Date()] )
        
        calendarView.backgroundColor = CALENDAR_BACKGROUND_COLOR
    }
    
    func parseEvents(events:[JSON]) -> [Date:[JSON]] {
        
        var eventDict = [Date:[JSON]]()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        
        for event in events {
            let eventDate = formatter.date(from: event["date"].stringValue)!
            if eventDict[eventDate] == nil {
                eventDict[eventDate] = [event]
            } else {
                eventDict[eventDate]!.append(event)
            }
        }
        return eventDict
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
//        let myCalendar = Calendar(identifier: .iso8601)
        let persianCalendar = Calendar(identifier: .gregorian)
        
        let testFormatter = DateFormatter()
        testFormatter.dateFormat = "yyyy/MM/dd"
        testFormatter.timeZone = persianCalendar.timeZone
        testFormatter.locale = persianCalendar.locale
        
        let startDate = testFormatter.date(from: "2017/01/01")!
        let endDate = testFormatter.date(from: "2018/12/31")!
        
//        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, calendar:persianCalendar)
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: nil, calendar: persianCalendar, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: nil, hasStrictBoundaries: nil)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        handleCellDisplay(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalenderCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        handleCellDisplay(cell: cell, cellState: cellState)
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellDisplay(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellDisplay(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        
        formatter.dateFormat = "yyyy"
        self.yearLabel.text = formatter.string(from: date!)
        
        formatter.dateFormat = "MMMM"
        self.monthLabel.text = formatter.string(from: date!)
    }
}


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = selectedEvents[indexPath.row]
        
        cell.eventNameLabel.text = event["name"].stringValue
        cell.locationLabel.text = event["location"].stringValue
        cell.eventNameLabel.font = UIFont(name:DEFAULT_FONT_BOLD, size:21)
        cell.locationLabel.font = UIFont(name:DEFAULT_FONT, size:16)
        cell.dateLabel.font = UIFont(name:DEFAULT_FONT, size:16)
        cell.timeLabel.font = UIFont(name:DEFAULT_FONT, size:16)
        formatter.dateFormat = "yyyy-MM-dd"
        if let eventDate = formatter.date(from: event["date"].stringValue) {
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            cell.dateLabel.text = formatter.string(from: eventDate)
        }
        
        formatter.dateFormat = "HH:mm:ss"
        if let eventTime = formatter.date(from: event["time"].stringValue) {
            formatter.dateFormat = "h:mm a"
            cell.timeLabel.text = formatter.string(from: eventTime)
        }
        
        // animate
        let delay = Double(indexPath.row) * 0.5
        cell.animate(.slide(way: .in, direction: .left)).delay( delay )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVc = AppStoryboard.Event.initialViewController() as! EventTableViewController
        nextVc.eventInfo = selectedEvents[indexPath.row]
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    
}

