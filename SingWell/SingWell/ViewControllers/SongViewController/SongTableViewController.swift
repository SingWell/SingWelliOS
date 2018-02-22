//
//  SongTableViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 2/14/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftyJSON
import IoniconsKit

let kSongInfo = "Song Info"
let kSongResources = "Song Resources"

class SongTableViewController: UITableViewController {
    
    let SECTIONS:[String] = [kSongInfo, kSongResources]
    
//    @IBOutlet weak var wv: UIWebView!
    
    var songInfo:JSON = [
        "name":"My Favorite Things",
        "composer":"John Coltrane",
        "instrumentation":"SATB"
    ]
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let youtubeURL = URL(string: "https://www.youtube.com/embed/MLS6qZt9WLQ")
//        wv.loadRequest(URLRequest(url: youtubeURL!))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SECTIONS[section] {
        case kSongInfo: // choir info cell
            return 1
        case kSongResources:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SECTIONS[indexPath.section] {
        case kSongInfo:
            return 147.0
        default:
            return 175.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SECTIONS[indexPath.section] {
        case kSongInfo: // song info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongInfoCell", for: indexPath) as! SongInfoTableViewCell
            
            cell.contentView.backgroundColor = BACKGROUND_COLOR
            
            cell.songNameLabel.text = songInfo["title"].stringValue
            cell.songNameLabel.font = cell.songNameLabel.font.withSize(20)
            cell.composerNameLabel.text = songInfo["composer"].stringValue
            
            
            let practiceImage = UIImage.ionicon(with: .androidMicrophone, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
            cell.practiceButton.setImage( practiceImage, for: UIControlState.normal)
            cell.practiceButton.semanticContentAttribute = .forceRightToLeft
            
//            cell.practiceButton. = UIImage.ionicon(with: .androidMicrophone, textColor: UIColor.black, size: CGSize(width: 35, height: 35))
            
            return cell
        case kSongResources: // song resource cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongResourceCell", for: indexPath) as! SongResourceTableViewCell
            
            let youtubeURL = NSURL(string: "https://www.youtube.com/embed/MLS6qZt9WLQ")
            
            let requestObject = URLRequest(url: youtubeURL! as URL)
            
            cell.wv.loadRequest(URLRequest(url: youtubeURL! as URL))
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! EventCell
            
            return cell
        }
        
    }
    
//    func loadYoutube(videoID:String) {
//        guard
//            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
//            else { return }
//        wv.loadRequest( URLRequest(url: youtubeURL) )
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
