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
//let kSongResources = "Song Resources"
let kSongYouTubeLink = "Song YouTube Link"
let kSongPDFResource = "Song PDF Resource"

class SongTableViewController: UITableViewController {
    
    let SECTIONS:[String] = [kSongInfo, kSongYouTubeLink, kSongPDFResource]
    
//    @IBOutlet weak var wv: UIWebView!
    
    var songInfo:JSON = [
        "name":"My Favorite Things",
        "composer":"John Coltrane",
        "instrumentation":"SATB"
    ]
    
    var song:JSON = [
        "arranger": "Test",
        "publisher" : "Back",
        "youtubeLink":"https://www.youtube.com/embed/DsUWFVKJwBM",
        "pdfName" : "Allegri Miserere Score.pdf"
    ]
    
    var songResources:[JSON] = []
    var pdfNum : [Int] = []
    
    var numYTLinks = 0
    var numPDF = 0
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMusicRecord()
        
    }
    
    func getMusicRecord() {
        ApiHelper.getMusicRecord(musicId: songInfo["id"].stringValue) { response, error in
            if error == nil {
                print(response)
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
        nextVc.filename = "TestMXL.mxl" // TODO: Download file!!
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func openPDF(_ sender: Any) {

//        getPDFResources()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SECTIONS[section] {
        case kSongInfo: // choir info cell
            return 1
        case kSongYouTubeLink:
//            for resource in songResources {
//                if resource["extension"].stringValue == "pdf" {
//
//                }
//            }
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
            return 200.0
        case kSongYouTubeLink:
            return 225.0
        case kSongPDFResource:
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
            if(songInfo["arranger"].stringValue != ""){
                cell.arrangerNameLabel.text = "Arranged By: " + songInfo["arranger"].stringValue
            }
            else {
                cell.arrangerNameLabel.isHidden = true
            }
            
            // Check if publisher data is available and diplay if it is
            if(songInfo["publisher"].stringValue != ""){
                if(cell.arrangerNameLabel.isHidden == true) {
                    
                    // If no arranger, use that label instead
                    cell.publisherNameLabel.isHidden = true
                    cell.arrangerNameLabel.isHidden = false
                    cell.arrangerNameLabel.text = "Published By: " + songInfo["publisher"].stringValue
                }
                else {
                    cell.publisherNameLabel.text = "Published By: " + songInfo["publisher"].stringValue
                }
            }
            else {
                cell.publisherNameLabel.isHidden = true
            }
            
            
            let practiceImage = UIImage.ionicon(with: .androidMicrophone, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
            cell.practiceButton.setImage( practiceImage, for: UIControlState.normal)
            cell.practiceButton.semanticContentAttribute = .forceRightToLeft
            cell.practiceButton.addTarget(self, action: #selector(goToPracticePage(_:)), for: .touchUpInside)
            
            return cell
        case kSongYouTubeLink: // song resource cell - youtube link
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongYouTubeCell", for: indexPath) as! SongYouTubeTableViewCell
            
//            let youtubeURL = NSURL(string: song["youtubeLink"].stringValue)
//            cell.wv.loadRequest(URLRequest(url: youtubeURL! as URL))
            
            return cell
            
        case kSongPDFResource: // song resource cell - pdf resource
            let resourceNum = pdfNum[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongPDFCell", for: indexPath) as! SongPDFTableViewCell
            
            cell.pdfNameLabel.text = songResources[resourceNum]["title"].stringValue
            
            let openImage = UIImage.ionicon(with: .chevronRight, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
            cell.openPDFButton.setImage( openImage, for: UIControlState.normal)
            cell.openPDFButton.semanticContentAttribute = .forceRightToLeft
            cell.openPDFButton.addTarget(self, action: #selector(openPDF(_:)), for: .touchUpInside)
            
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! EventCell
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
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
    
    func getPDFResources(resourceID: String, recordID: String, fileName: String) {

        

        ApiHelper.downloadPDF(path: "resource", resourceID: resourceID, recordID: recordID) { data, error in
            if error == nil {
////                self.saveBase64StringToPDF(data)
//                print("data", data)
                let convertedData = Data(base64Encoded: data!)
//                print("converted data", convertedData)
                self.showPDF(fileData: convertedData!, fileName: fileName)
                
//                self.showPDF(fileData: data!, fileName: "Mozart Ave Verum.pdf")
//                let fileManager = FileManager.default
//                do {
//                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//                    let fileURL = documentDirectory.appendingPathComponent("AveVerumMozart.xml")
//                    try data!.write(to: fileURL)
//
//                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
//                    print(directoryContents)
//
//                    let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" }
//                    print("xml urls:",xmlFiles)
//                } catch {
//                    print(error)
//                }
            } else {
                print("Error getting musicRecords: ",error as Any)
            }
        }
    }
    
    func saveBase64StringToPDF(_ base64String: String) {
        
        guard
            var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
            let convertedData = Data(base64Encoded: base64String)
            else {
                //handle error when getting documents URL
                return
        }
        
        //name your file however you prefer
        documentsURL.appendPathComponent("yourFileName.pdf")
        
        do {
            try convertedData.write(to: documentsURL)
            self.showPDF(fileData: convertedData, fileName: "Mozart Ave Verum.pdf")
        } catch {
            //handle write error here
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
