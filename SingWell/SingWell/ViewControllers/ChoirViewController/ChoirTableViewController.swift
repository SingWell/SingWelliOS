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
    
    let BACKGROUND_COLOR = UIColor.init(hexString: "eeeeee")
    
    var choirInfo:JSON = ["name":"Choir A"]

    var choirUpdatesList:JSON = [
        ["title":"Event Changed", "info":"The time for mass changed to 12:00pm-1:30pm.", "time":"1 hour ago"],
        ["title":"New Event Added", "info":"There will be a mass on Sunday, November 22 from 10:30am-12:00pm.", "time":"2 days ago"]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = choirInfo["name"].stringValue
        
        
        
        self.tableView.backgroundColor = BACKGROUND_COLOR
//        self.edgesForExtendedLayout = UIRectEdge
//        self.extendedLayoutIncludesOpaqueBars = NO
//        self.automaticallyAdjustsScrollViewInsets = NO
        
        setNavigationItems()
        
        self.view.frame = self.view.bounds
        
//        ApiHelper.getOrganizations() { response, error in
//            print(response)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if FIRST_CONTROLLER == true {
//            self.additionalSafeAreaInsets = UIEdgeInsetsMake(0,0,0,0)
//            FIRST_CONTROLLER = false
//            print("FIRST CONTROLLER")
//        } else {
//            self.additionalSafeAreaInsets = UIEdgeInsetsMake(20,0,0,0)
//        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choirUpdatesList.arrayValue.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicUpdateCell", for: indexPath) as! ChoirResourceInfoTableViewCell
        let info = choirUpdatesList[indexPath.row]
        
        cell.titleLabel.text = info["title"].stringValue
        cell.descriptionField.text = info["info"].stringValue

        cell.contentView.backgroundColor = BACKGROUND_COLOR
        return cell
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
