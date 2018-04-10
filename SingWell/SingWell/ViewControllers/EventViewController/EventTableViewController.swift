//
//  EventTableViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 3/8/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftyJSON

let kEventInfo = "Event Info"
let kProgramCell = "Program"

class EventTableViewController: AnimatableTableViewController {
    
    let SECTIONS:[String] = [kEventInfo, kProgramCell]
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")
    
    let CONTENT_COLOR = UIColor.init(hexString: "ffffff")
    
    var eventInfo:JSON = [
        "id": 1,
        "name": "Event Name",
        "date": "2017-11-26",
        "time": "23:00:00",
        "location": "Chapel",
        "choirs": [
            1,
            3
        ],
        "organization": 1
    ]
    
    var program:[JSON] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = eventInfo["name"].stringValue
        
//        print(eventInfo)
        
        program = eventInfo["program_music"].arrayValue
        
        self.tableView.backgroundColor = BACKGROUND_COLOR
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSong(indexPath:IndexPath) {
        let nextVc = AppStoryboard.Song.initialViewController() as! SongTableViewController
        nextVc.songInfo = program[indexPath.row]
        nextVc.songInfo["id"] = program[indexPath.row]["music_record"]
        self.navigationController?.pushViewController(nextVc, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SECTIONS[section] {
        case kEventInfo: // event info cell
            return 1
        default:
            var count = 0
            for _ in program {
                count += 1
            }
            return count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SECTIONS[indexPath.section] {
        case kEventInfo:
            return 200.0
        default:
            return 120.0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SECTIONS[indexPath.section] {
        case kEventInfo: // Event info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventInfoCell", for: indexPath) as! EventInfoTableViewCell
            
            cell.contentView.backgroundColor = CONTENT_COLOR
            
            cell.eventNameLabel.text = eventInfo["name"].stringValue
            cell.eventLocationLabel.text = eventInfo["location"].stringValue
            
            let formatter = DateFormatter()
            formatter.timeZone = .current
            formatter.locale = .current
            
            formatter.dateFormat = "yyyy-MM-dd"
            if let eventDate = formatter.date(from: eventInfo["date"].stringValue) {
                formatter.dateFormat = "EEEE, MMM d, yyyy"
                cell.eventDateLabel.text = formatter.string(from: eventDate)
            }
            
            formatter.dateFormat = "HH:mm:ss"
            if let eventTime = formatter.date(from: eventInfo["time"].stringValue) {
                formatter.dateFormat = "h:mm a"
                cell.eventTimeLabel.text = formatter.string(from: eventTime)
            }
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramCell", for: indexPath) as! ProgramTableViewCell
            
            cell.fieldTitleLabel.text = program[indexPath.row]["field_title"].stringValue
            cell.songTitleLabel.text = program[indexPath.row]["title"].stringValue
            cell.songTitleLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
            cell.composerLabel.text = program[indexPath.row]["composer"].stringValue
            cell.NotesLabel.text = program[indexPath.row]["notes"].stringValue
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch SECTIONS[indexPath.section] {
        case kEventInfo:
            print("Do nothing!")
        default:
            viewSong(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch SECTIONS[section] {
        case kEventInfo:
            return ""
        case kProgramCell:
            return kProgramCell
        default:
            return ""
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
