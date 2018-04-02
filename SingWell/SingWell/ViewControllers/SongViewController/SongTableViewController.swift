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
import PDFReader

let kSongInfo = "Song Info"
let kSongYouTubeLink = "Song YouTube Link"
let kSongPDFResource = "Song PDF Resource"
let kPractice = "Song Practice"

class SongTableViewController: UITableViewController {
    
    let SECTIONS:[String] = [kSongInfo, kPractice, kSongYouTubeLink, kSongPDFResource]
    
    var songInfo:JSON = [
        "title":"My Favorite Things",
        "composer":"John Coltrane",
        "instrumentation":"SATB"
    ]
    
    var song:JSON = [
        "arranger": "Test",
        "publisher" : "Back",
        "youtubeLink":"https://www.youtube.com/embed/DsUWFVKJwBM",
        "pdfName" : "Allegri Miserere Score.pdf"
    ]
    
    var youtubeLink = "https://www.youtube.com/embed/DsUWFVKJwBM"
    var songResources:[JSON] = []
    var pdfNum : [Int] = []
    var mxlNum : [Int] = []
    var ytNum : [Int] = []
    
    var numYTLinks = 0
    var numPDF = 0
    var numML = 0
    var mxlFilename = "TestMXL.mxl"
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.clearAllFilesFromTempDirectory()
        
        self.getMusicRecord()
        
    }
    
    func getMusicRecord() {
        ApiHelper.getMusicRecord(musicId: songInfo["id"].stringValue) { response, error in
            if error == nil {
                self.song = response!
                self.songResources = self.song["music_resources"].arrayValue
                self.tableView.reloadData()
            } else {
                print("Error getting musicRecord: ",error as Any)
            }
        }
    }
    
    @IBAction func goToPracticePage(_ sender: Any) {
        let nextVc = AppStoryboard.Practice.initialViewController() as! PracticeViewController
        print("LOADING: ",mxlFilename)
        nextVc.filename = mxlFilename
        nextVc.songName = songInfo["title"].stringValue
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func openPDF(_ sender: Any) {

//        getPDFResources()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SECTIONS[section] {
        case kSongInfo: // choir info cell
            return 1
        case kPractice:
            var count = 0
            for resource in songResources {
                if resource["extension"].stringValue == "xml" {
                    saveMXLFile(resourceID: resource["resource_id"].stringValue, recordID: songInfo["id"].stringValue, fileName: resource["title"].stringValue)
                    mxlNum.append(count)
                    numML += 1
                }
                if resource["extension"].stringValue == "mxl" {
                    saveMXLFile(resourceID: resource["resource_id"].stringValue, recordID: songInfo["id"].stringValue, fileName: resource["title"].stringValue)
                    mxlNum.append(count)
                    numML += 1
                }
                count += 1
            }
            return numML
        case kSongYouTubeLink:
            var count = 0
            for resource in songResources {
                if resource["type"].stringValue == "youtube_link" {
                    numYTLinks += 1
                    ytNum.append(count)
                }
                count += 1
            }
            return numYTLinks
        case kSongPDFResource:
            var count = 0
            for resource in songResources {
                if resource["extension"].stringValue == "pdf" {
                    pdfNum.append(count)
                    numPDF += 1
                }
                count += 1
            }
            return numPDF
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SECTIONS[indexPath.section] {
        case kSongInfo:
            return 150.0
        case kSongYouTubeLink:
            return 285.0
        case kSongPDFResource:
            return 75.0
        case kPractice:
            return 75.0
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
            cell.songNameLabel.font = cell.songNameLabel.font.withSize(25)
            
            cell.composerNameLabel.text = "Composed By: " + songInfo["composer"].stringValue
            
            // Check if arranger data is available and diplay if it is
            if(song["arranger"].stringValue != ""){
                cell.arrangerNameLabel.text = "Arranged By: " + song["arranger"].stringValue
            }
            else {
                cell.arrangerNameLabel.isHidden = true
            }
            
            // Check if publisher data is available and diplay if it is
            if(song["publisher"].stringValue != ""){
                if(cell.arrangerNameLabel.isHidden == true) {
                    
                    // If no arranger, use that label instead
                    cell.publisherNameLabel.isHidden = true
                    cell.arrangerNameLabel.isHidden = false
                    cell.arrangerNameLabel.text = "Published By: " + song["publisher"].stringValue
                }
                else {
                    cell.publisherNameLabel.text = "Published By: " + song["publisher"].stringValue
                }
            }
            else {
                cell.publisherNameLabel.isHidden = true
            }
            
            return cell
        case kSongYouTubeLink: // song resource cell - youtube link
            let resourceNum = ytNum[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongYouTubeCell", for: indexPath) as! SongYouTubeTableViewCell
            
            let youtubeURL = NSURL(string: songResources[resourceNum]["url"].stringValue)
            cell.wv.loadRequest(URLRequest(url: youtubeURL! as URL))
            cell.songTitle.text = "Title: " + songResources[resourceNum]["title"].stringValue
            if(songResources[resourceNum]["description"].stringValue != ""){
                cell.descriptionLabel.text = "Notes: " + songResources[resourceNum]["description"].stringValue
            }
            else {
                cell.descriptionLabel.text = ""
            }
            return cell
            
        case kSongPDFResource: // song resource cell - pdf resource
            let resourceNum = pdfNum[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongPDFCell", for: indexPath) as! SongPDFTableViewCell
            
            cell.pdfNameLabel.text = songResources[resourceNum]["title"].stringValue
            
            return cell
            
        case kPractice: // song resource cell - pdf resource
            let resourceNum = mxlNum[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeCell", for: indexPath) as! PracticeTableViewCell
            
            cell.mxlNameLabel.text = songResources[resourceNum]["title"].stringValue
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! EventCell
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let resourceNum = mxlNum[indexPath.row]
//            mxlFilename = songResources[resourceNum]["title"].stringValue
//            goToPracticePage(_:)
            let nextVc = AppStoryboard.Practice.initialViewController() as! PracticeViewController
            print("LOADING: ",mxlFilename)
            nextVc.filename = songResources[resourceNum]["title"].stringValue
            
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        if indexPath.section == 3 {
            let resourceNum = pdfNum[indexPath.row]
            getPDFResources(resourceID: songResources[resourceNum]["resource_id"].stringValue, recordID:songInfo["id"].stringValue, fileName: songResources[resourceNum]["title"].stringValue)
        }
        
    }
    
    func showPDF(fileData:Data, fileName:String) {
        if let document = PDFDocument(fileData: fileData, fileName: fileName) {

            let readerController = PDFViewController.createNew(with: document,actionStyle:.activitySheet)

            navigationController?.pushViewController(readerController, animated: true)
        } else {
            let alert = UIAlertController(title: "File Corrupted", message: "The file could not be displayed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in

            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveMXLFile (resourceID: String, recordID: String, fileName: String){
        ApiHelper.downloadPDF(path: "resource", resourceID: resourceID, recordID: recordID) { data, error in
            if error == nil {
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                    let fileURL = documentDirectory.appendingPathComponent(fileName)
                    let convertedData = Data(base64Encoded: data!)
                    try convertedData!.write(to: fileURL, options: .atomic)
                    } catch {
                        print(error)
                    }
            } else {
                print("Error getting musicRecords: ",error as Any)
            }
        }
        mxlFilename = fileName
    }
    
    func clearAllFilesFromTempDirectory(){
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let docDirectory = documentDirectory.absoluteString
            let filePaths = try fileManager.contentsOfDirectory(atPath: docDirectory)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: docDirectory + filePath)
            }
        } catch {
            print(error)
        }
    }
    
    func getPDFResources(resourceID: String, recordID: String, fileName: String) {

        ApiHelper.downloadPDF(path: "resource", resourceID: resourceID, recordID: recordID) { data, error in
            if error == nil {
                let convertedData = Data(base64Encoded: data!)
                self.showPDF(fileData: convertedData!, fileName: fileName)
            } else {
                print("Error getting musicRecords: ",error as Any)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch SECTIONS[section] {
        case kPractice:
            return "Song Resources"
        default:
            return ""
        }
    }

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

extension UILabel
{
    func addImage(image: UIImage, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = image
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
