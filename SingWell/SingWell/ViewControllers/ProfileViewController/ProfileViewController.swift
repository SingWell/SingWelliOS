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

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var userId = ""
    
    @IBOutlet weak var contactView: AnimatableView!
    @IBOutlet weak var biographyView: AnimatableView!
    @IBOutlet weak var addressView: AnimatableView!
    
    @IBOutlet weak var phoneNumberLabel: AnimatableLabel!
    @IBOutlet weak var emailLabel: AnimatableLabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var biographyTextView: AnimatableTextView!
    
    var instruments = ["trumpet", "drum", "piano", "guitar"]
    var user:JSON = []
    
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
    
    func setProfile() {
        
        if(self.user["bio"].exists()){
            biographyView.isHidden = false
            biographyTextView.text = self.user["bio"].stringValue
        }
        else{
            biographyView.isHidden = true
        }
        
        if(self.user["email"].exists()){
            emailLabel.text = self.user["email"].stringValue
            emailLabel.isHidden = false
        }
        else {
            emailLabel.isHidden = true
        }
        if(self.user["phone_number"].exists()){
            phoneNumberLabel.text = self.user["phone_number"].stringValue
//            phoneNumberLabel.isHidden = false
        }
        else {
            phoneNumberLabel.text = "No Phone Number"
//            phoneNumberLabel.isHidden = true
        }
        
        if(!self.user["email"].exists() && !self.user["phone_number"].exists()){
            contactView.isHidden = true
        }
        else {
            contactView.isHidden = false
        }
        
        if(self.user["address"].exists()){
            addressView.isHidden = false
            addressLabel.text = self.user["address"].stringValue
            addressLabel.isHidden = false
        }
        else {
            addressLabel.isHidden = true
        }
        
        if(self.user["city"].exists()){
            addressView.isHidden = false
            var tempAddLabel = self.user["city"].stringValue
            if(self.user["zip_code"].exists()){
                let tempZip = self.user["zip_code"].stringValue
                tempAddLabel += ", "
                tempAddLabel += tempZip
            }
            cityLabel.text = tempAddLabel
            cityLabel.isHidden = false
        }
        else {
            cityLabel.isHidden = true
        }
        
        if(!self.user["address"].exists() && !self.user["city"].exists()){
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
        //        print(self.user)
        
        var profileName = ""
        if(self.user != []){
            profileName = self.user["username"].stringValue
        }
        
        profileNameLabel.text = profileName
    }
    
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileNameLabel: AnimatableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
        instrumentCollectionView.delegate = (self as UICollectionViewDelegate)
        instrumentCollectionView.dataSource = (self as UICollectionViewDataSource)
        
        self.title = "Profile"
        setNavigationItems()
        setEditButton()
        setNotificationButton()
        
        setInstrumentItems()
        setProfile()

        // Do any additional setup after loading the view.
        
        contactIcon.image = UIImage.ionicon(with: .chatbubble, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        bioIcon.image = UIImage.ionicon(with: .iosPaperOutline, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        instrumentationButton.image = UIImage.ionicon(with: .headphone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userId != "" {
//            Hide Navigation items
            
//            Hide Edit and Notification Buttons
            notificationImageView.isHidden = true
            notificationButton.isHidden = true
            editButton.isHidden = true
            editImageView.isHidden = true
        }
        else {
//            Hide Navigation items
            
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
        nextVc.cityPassed = cityLabel.text!
        nextVc.streetPassed = addressLabel.text!
        nextVc.emailPassed = emailLabel.text!
        nextVc.phoneNumberPassed = phoneNumberLabel.text!
        
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
                self.user = response!
                print(self.user)
                
                self.setProfile()
            } else {
                print(error!)
            }
        }
    }
    
//    func reloadView() {
//        setProfile()
////        var profileName = ""
////        if(self.user != []){
////            profileName = self.user["username"].stringValue
////        }
////
////        profileNameLabel.text = profileName
//
//    }
    

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


