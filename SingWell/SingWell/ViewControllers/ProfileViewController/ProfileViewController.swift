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
import SwiftyJSON
import MessageUI

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)

    }
    
    
    var userId = ""
    
    @IBOutlet weak var contactView: AnimatableView!
    @IBOutlet weak var biographyView: AnimatableView!
    @IBOutlet weak var addressView: AnimatableView!
    
    @IBOutlet weak var phoneNumberButton: AnimatableButton!
    @IBOutlet weak var emailButton: AnimatableButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var biographyTextView: AnimatableTextView!
    
    var instruments = ["trumpet", "drum", "piano", "guitar"]
    var user:JSON = []
    var rosterUser:JSON = []
    
    @IBAction func phoneNumberTap(_ sender: Any) {
        print("tapped Number")
        
        if (MFMessageComposeViewController.canSendText() == true) {
//                        let controller = MFMessageComposeViewController()
//                        controller.body = "Message Body"
//            controller.recipients = [phoneNumberButton.title(for: .normal)!]
//                        controller.messageComposeDelegate = self
//                        self.present(controller, animated: true, completion: nil)
//                    }
            let recipients:[String] = [phoneNumberButton.title(for: .normal)!]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = ""
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
        }
    }
    
    // Mail only works if the native Mail apple app is installed and set up with acount
    @IBAction func launchEmail(sender: AnyObject) {
        print("Tapped Email")
        
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailButton.title(for: .normal)!])
            mail.setSubject("")
            mail.setMessageBody("", isHTML: false)
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion:nil)
    }
    
    //    @IBOutlet weak var cellImageView: UIImageView!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath)
        
        let size = CGSize(width: 35, height:35)
        
        switch(indexPath.row) {
        case 0:
            var icon: UIImage = UIImage(named: "trumpetIcon")!
            icon = self.resizeImage(image: icon, targetSize: size)
            let imageView: UIImageView = UIImageView(image: icon)
            cell.contentView.addSubview(imageView)
        case 1:
            var icon: UIImage = UIImage(named: "drumIcon")!
            //            icon = icon.resizeImageWith(newSize: size)
            icon = self.resizeImage(image: icon, targetSize: size)
            let imageView: UIImageView = UIImageView(image: icon)
            cell.contentView.addSubview(imageView)
        case 2:
            var icon: UIImage = UIImage(named: "pianoIcon")!
            icon = self.resizeImage(image: icon, targetSize: size)
            let imageView: UIImageView = UIImageView(image: icon)
            cell.contentView.addSubview(imageView)
        case 3:
            var icon: UIImage = UIImage(named: "guitarIcon")!
            icon = self.resizeImage(image: icon, targetSize: size)
            let imageView: UIImageView = UIImageView(image: icon)
            cell.contentView.addSubview(imageView)
        case 4:
            var icon: UIImage = UIImage(named: "sIcon")!
            icon = self.resizeImage(image: icon, targetSize: size)
            let imageView: UIImageView = UIImageView(image: icon)
            cell.contentView.addSubview(imageView)
        default:
            print("No instruments")
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.instruments.count
    }
    
    @IBOutlet weak var menuItem: AnimatableBarButtonItem!
    
    // Edit Button
    @IBOutlet weak var editImageView: AnimatableImageView!
    @IBOutlet weak var editButton: AnimatableButton!
    
    // Instrumentation Stuff
    @IBOutlet weak var instrumentCollectionView: UICollectionView!
    
    // Settings Button
    @IBOutlet weak var notificationButton: AnimatableButton!
    @IBOutlet weak var notificationImageView: AnimatableImageView!
    
    // Icons to display on side
    @IBOutlet weak var contactIcon: AnimatableImageView!
    @IBOutlet weak var bioIcon: AnimatableImageView!
    @IBOutlet weak var addressIcon: AnimatableImageView!
    @IBOutlet weak var instrumentationButton: AnimatableImageView!
    
    let collectionViewIdentifier = "instrumentCellView"
    
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    
    @IBAction func unwindToSaveProfile(_ sender: UIStoryboardSegue) {
        // Refresh data
    }
    
    func setNavigationItems() {
        menuItem.title = ""
        menuItem.tintColor = .black
        menuItem.image = UIImage.ionicon(with: .navicon, textColor: UIColor.black, size: CGSize(width: 35, height: 35))
    }
    
    func setInstrumentItems() {
        
        // Trying to use a collection view to display icons
        
    }
    
    func setEditButton() {
        let size = CGSize(width:55, height: 55)
        var backImage: UIImage = UIImage(named: "editButtonBackground")!
        backImage = backImage.resizeImageWith(newSize: size)
        backImage = backImage.circleMasked!
        editImageView.image = backImage
        
        let editImage = UIImage.ionicon(with: .edit, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        editButton.setImage( editImage, for: UIControlState.normal)
    }
    
    func setNotificationButton() {
        let size = CGSize(width:55, height: 55)
        var backImage: UIImage = UIImage(named: "editButtonBackground2")!
        backImage = backImage.resizeImageWith(newSize: size)
        backImage = backImage.circleMasked!
        notificationImageView.image = backImage
        
        let notificationImage = UIImage.ionicon(with: .gearA, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        notificationButton.setImage( notificationImage, for: UIControlState.normal)
    }
    
    func setProfile(user:JSON) {
        
        if(user["bio"].exists()){
            biographyView.isHidden = false
            biographyTextView.text = user["bio"].stringValue
        }
        else{
            biographyView.isHidden = true
        }
        
        if(user["email"].exists()){
            emailButton.setTitle(user["email"].stringValue, for: .normal)
            emailButton.isHidden = false
        }
        else {
            emailButton.isHidden = true
        }
        if(user["phone_number"].exists()){
            phoneNumberButton.setTitle(user["phone_number"].stringValue, for: .normal)
//                = user["phone_number"].stringValue
//            phoneNumberLabel.isHidden = false
        }
        else {
            phoneNumberButton.setTitle("9999999999", for: .normal)
//            phoneNumberButton.titleLabel?.text = "9999999999"
//            phoneNumberLabel.isHidden = true
        }
        
        if(!user["email"].exists() && !user["phone_number"].exists()){
            contactView.isHidden = true
        }
        else {
            contactView.isHidden = false
        }
        
        if(self.user["address"].exists()){
            addressView.isHidden = false
            addressLabel.text = user["address"].stringValue
            addressLabel.isHidden = false
        }
        else {
            addressLabel.isHidden = true
        }
        
        if(user["city"].exists()){
            addressView.isHidden = false
            var tempAddLabel = user["city"].stringValue
            if(user["state"].exists()){
                let tempState = user["state"].stringValue
                tempAddLabel += ", "
                tempAddLabel += tempState
            }
            if(user["zip_code"].exists()){
                let tempZip = user["zip_code"].stringValue
                tempAddLabel += " "
                tempAddLabel += tempZip
            }
            cityLabel.text = tempAddLabel
            cityLabel.isHidden = false
        }
        else {
            cityLabel.isHidden = true
        }
        
        if(!user["address"].exists() && !user["city"].exists()){
            addressView.isHidden = true
        }
        else {
            addressView.isHidden = false
        }
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        profileImageView.image = profileImage
        
        let profileBackgroundImage: UIImage = UIImage(named: "profileBackground")!
        profileBackgroundImageView.image = profileBackgroundImage
        
        var profileName = ""
        if(user != []){
            profileName = user["username"].stringValue
        }
        if(profileName == ""){
            profileName = "Kenton Kravig"
        }
        
        profileNameLabel.text = profileName
    }
    
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileNameLabel: AnimatableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfile()
        
        instrumentCollectionView.delegate = (self as UICollectionViewDelegate)
        instrumentCollectionView.dataSource = (self as UICollectionViewDataSource)
        
        self.title = "Profile"
//        setNavigationItems()
        setEditButton()
        setNotificationButton()
        
        setInstrumentItems()
        setProfile(user: self.user)

        // Do any additional setup after loading the view.
        
        contactIcon.image = UIImage.ionicon(with: .chatbubble, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        bioIcon.image = UIImage.ionicon(with: .iosPaperOutline, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        instrumentationButton.image = UIImage.ionicon(with: .headphone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userId != "" {
//            Hide Navigation items
            
            //get user information
            getUser()
            
//            Hide Edit and Notification Buttons
            notificationImageView.isHidden = true
            notificationButton.isHidden = true
            editButton.isHidden = true
            editImageView.isHidden = true
        }
        else {
//            View Navigation items
            
            //get user information
            getProfile()
            
            // Add Menu button on navigation bar programmatically
            var menuBtn = AnimatableButton(type: .custom)
            menuBtn.setTitle("", for: .normal)
            menuBtn.tintColor = .black
            menuBtn.setImage(UIImage.ionicon(with: .navicon, textColor: UIColor.black, size: CGSize(width: 35, height: 35)), for: .normal)
            menuBtn.addTarget(self, action: #selector(ProfileViewController.openMenu(_:)), for: .touchUpInside)
            
            let menuItem = AnimatableBarButtonItem(customView: menuBtn)
            
            self.navigationItem.leftBarButtonItem = menuItem
            
//            View Edit and Notification Buttons
            notificationImageView.isHidden = false
            notificationButton.isHidden = false
            editButton.isHidden = false
            editImageView.isHidden = false
            
        }
        userId = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editProfile(_ sender: Any) {
    
//        let nextVc = AppStoryboard.EditProfile.initialViewController() as! EditProfileViewController
        let nextVc = AppStoryboard.NewEditProfile.initialViewController() as! NewEditProfileViewController
        
        nextVc.profileNamePassed = profileNameLabel.text!
        nextVc.biographyPassed = biographyTextView.text!
        nextVc.cityPassed = self.user["city"].stringValue
        nextVc.statePassed = self.user["state"].stringValue
        nextVc.zipPassed = self.user["zip_code"].stringValue
        
        nextVc.streetPassed = addressLabel.text!
        nextVc.emailPassed = emailButton.title(for: .normal)!
        nextVc.phoneNumberPassed = phoneNumberButton.title(for: .normal)!
//            (phoneNumberButton.titleLabel?.text!)!
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        
//        let presentingVC = AppStoryboard.SettingsModal.initialViewController()
        
//        SettingsModelViewController.contextFrameForPresentation = presentingVC.view.frame
//        SettingsModelViewController.present(presentingVC, animated: true)
        
//        let storyboard = UIStoryboard(name: "Presentations", bundle: nil)
        let presentingVC = AppStoryboard.SettingsModal.initialViewController()
        if let presentedViewController = presentingVC as? AnimatableModalViewController {
//            setupModal(for: presentedViewController)
            present(presentedViewController, animated: true, completion: nil)
        }
        
    }
    
    func getProfile() {
        var curUser = ""
        if userId == "" {
            curUser = "4"
        }
        else{
            curUser = userId
        }
        ApiHelper.getProfile(userId: curUser) { response, error in
            if error == nil {
                self.user = response!
                print(self.user)
                
                self.setProfile(user:self.user)
            } else {
                print(error!)
            }
        }
    }
    
    func getUser() {
        var curUser = ""
        if userId == "" {
            curUser = "4"
        }
        else{
            curUser = userId
        }
        ApiHelper.getUser(userId: curUser) { response, error in
            if error == nil {
                self.rosterUser = response!
                print(self.rosterUser)
                
                self.setProfile(user: self.rosterUser)
            } else {
                print(error!)
            }
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    


}


