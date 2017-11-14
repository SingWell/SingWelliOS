//
//  ProfileViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 11/8/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import IBAnimatable
import IoniconsKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var menuItem: AnimatableBarButtonItem!
    @IBOutlet weak var editImageView: AnimatableImageView!
    @IBOutlet weak var editButton: AnimatableButton!
    @IBOutlet weak var contactIcon: AnimatableImageView!
    @IBOutlet weak var bioIcon: AnimatableImageView!
    @IBOutlet weak var addressIcon: AnimatableImageView!
    
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    
    func setNavigationItems() {
        menuItem.title = ""
        menuItem.tintColor = .black
        menuItem.image = UIImage.ionicon(with: .navicon, textColor: UIColor.black, size: CGSize(width: 35, height: 35))
    }
    
    func setEditButton() {
//        let size = CGSize(width:55, height: 55)
//        var backImage: UIImage = UIImage(named: "profileImage")!
//        backImage = backImage.getImageWithColor(color: UIColor.gray , size: size)
//        backImage = backImage.circleMasked!
//        editImageView.image = backImage
//        
//        let editImage = UIImage.ionicon(with: .edit, textColor: UIColor.black, size: CGSize(width: 25, height: 25))
////        editImage = editImage.maskWithColor(color: UIColor.blue)!
////        editImage = editImage.circleMasked!
////        var profileImage: UIImage = UIImage(named: "profileImage")!
////        profileImage = profileImage.circleMasked!
//        editButton.setImage( editImage, for: UIControlState.normal)
    }
    
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileNameLabel: AnimatableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        setNavigationItems()
        setEditButton()

        // Do any additional setup after loading the view.
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        profileImageView.image = profileImage
        
        var profileBackgroundImage: UIImage = UIImage(named: "profileBackground")!
        profileBackgroundImageView.image = profileBackgroundImage
        
        var profileName = "User Name"
        profileNameLabel.text = profileName
        
        contactIcon.image = UIImage.ionicon(with: .chatbubble, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        bioIcon.image = UIImage.ionicon(with: .person, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

