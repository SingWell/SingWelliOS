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

var userProfilePicture : UIImage = UIImage(named: "profileImage")!

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var userId = ""
    
    @IBOutlet weak var emailIcon: AnimatableImageView!
    @IBOutlet weak var contactView: AnimatableView!
    @IBOutlet weak var biographyView: AnimatableView!
    @IBOutlet weak var addressView: AnimatableView!
    
    @IBOutlet weak var emailView: AnimatableView!
    @IBOutlet weak var birthdayView: AnimatableView!
    @IBOutlet weak var phoneNumberLabel: AnimatableLabel!
    @IBOutlet weak var emailLabel: AnimatableLabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var biographyTextView: AnimatableTextView!
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayIcon: AnimatableImageView!
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
//        setProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProfile()
    }
    
    func setNavigationItems() {
        // Add Menu button on navigation bar programmatically
        var menuBtn = AnimatableButton(type: .custom)
        menuBtn.setTitle("", for: .normal)
        menuBtn.tintColor = .black
        menuBtn.setImage(UIImage.ionicon(with: .navicon, textColor: UIColor.black, size: CGSize(width: 35, height: 35)), for: .normal)
        menuBtn.addTarget(self, action: #selector(ProfileViewController.openMenu(_:)), for: .touchUpInside)
        
        let menuItem = AnimatableBarButtonItem(customView: menuBtn)
        
        self.navigationItem.leftBarButtonItem = menuItem
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
        
        let notificationImage = UIImage.ionicon(with: .logOut, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        notificationButton.setImage( notificationImage, for: UIControlState.normal)
    }
    
    func setProfile(user:JSON) {
        
        if(user["profile"]["bio"].stringValue != ""){
            biographyView.isHidden = false
            biographyTextView.text = user["profile"]["bio"].stringValue
            biographyTextView.font = UIFont(name:DEFAULT_FONT, size:14)
        }
        else{
            biographyView.isHidden = true
        }
        
        if(user["profile"]["date_of_birth"].stringValue != ""){
            birthdayView.isHidden = false
            birthdayLabel.text = user["profile"]["date_of_birth"].stringValue
            birthdayLabel.font = UIFont(name:DEFAULT_FONT, size:14)
        }
        else{
            birthdayView.isHidden = true
        }
        
        if(user["email"].stringValue != ""){
            emailLabel.text = user["email"].stringValue
            emailView.isHidden = false
        }
        else {
            emailView.isHidden = true
        }
        
        if(user["profile"]["phone_number"].stringValue != ""){
            phoneNumberLabel.text = user["profile"]["phone_number"].stringValue
            contactView.isHidden = false
        }
        else {
            phoneNumberLabel.text = ""
            contactView.isHidden = true
        }
        
//        if(!(user["email"].stringValue != "") && !(user["profile"]["phone_number"].stringValue != "")){
//            contactView.isHidden = true
//        }
//        else {
//            contactView.isHidden = false
//        }
        
        if(user["profile"]["address"].stringValue != ""){
            addressView.isHidden = false
            addressLabel.text = user["profile"]["address"].stringValue
            addressLabel.isHidden = false
        }
        else {
            addressLabel.isHidden = true
        }
        
        if(user["profile"]["city"].stringValue != ""){
            addressView.isHidden = false
            var tempAddLabel = user["profile"]["city"].stringValue
            if(user["profile"]["state"].exists()){
                let tempState = user["profile"]["state"].stringValue
                tempAddLabel += ", "
                tempAddLabel += tempState
            }
            if(user["profile"]["zip_code"].stringValue != ""){
                let tempZip = user["profile"]["zip_code"].stringValue
                tempAddLabel += " "
                tempAddLabel += tempZip
            }
            cityLabel.text = tempAddLabel
            cityLabel.isHidden = false
        }
        else {
            cityLabel.isHidden = true
        }
        
        if(!(user["profile"]["address"].stringValue != "") && !(user["profile"]["city"].stringValue != "")){
            addressView.isHidden = true
        }
        else {
            addressView.isHidden = false
        }
        
        let profileBackgroundImage: UIImage = UIImage(named: "profileBackground")!
        profileBackgroundImageView.image = profileBackgroundImage
        
        var profileName = ""
        if(user != []){
            profileName = user["first_name"].stringValue + " " + user["last_name"].stringValue
        }
        if(profileName == ""){
            profileName = "No Name"
        }
        
        profileNameLabel.text = profileName
        
        var tempImage = userProfilePicture
        tempImage = tempImage.circleMasked!
        profileImageView.image = tempImage
        
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
        setNavigationItems()
        setEditButton()
        setNotificationButton()
        
        setInstrumentItems()
        setProfile(user: self.user)

        // Do any additional setup after loading the view.
        
        contactIcon.image = UIImage.ionicon(with: .iosTelephone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        emailIcon.image = UIImage.ionicon(with: .email, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        bioIcon.image = UIImage.ionicon(with: .iosPaperOutline, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        birthdayIcon.image = UIImage.ionicon(with: .iosCalendar, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        instrumentationButton.image = UIImage.ionicon(with: .headphone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
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
        nextVc.cityPassed = self.user["profile"]["city"].stringValue
        nextVc.statePassed = self.user["profile"]["state"].stringValue
        nextVc.zipPassed = self.user["profile"]["zip_code"].stringValue
        
        nextVc.streetPassed = addressLabel.text!
        nextVc.emailPassed = emailLabel.text!
        nextVc.profileImagePassed = profileImageView.image!
        nextVc.phoneNumberPassed = phoneNumberLabel.text!
        nextVc.birthdayPassed = birthdayLabel.text!
        
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
        ApiHelper.getPicture(path: "pictures", id: ApiHelper.userId, type: "profile") { data, error in
            if error == nil {
                var decodedimage:UIImage
                let convertedData = Data(base64Encoded: data!)
                if(convertedData != nil){
                    decodedimage = UIImage(data: convertedData!)!
                }
                else {
                     decodedimage = UIImage(named: "profileImage")!
                }
                userProfilePicture = decodedimage
                decodedimage = decodedimage.circleMasked!
                self.profileImageView.image = decodedimage
            } else {
                print("Error getting profilePic: ",error as Any)
            }
        }
        
        ApiHelper.getUser(userId: ApiHelper.userId) { response, error in
            if error == nil {
                self.user = response!
                print(self.user)
                
                self.setProfile(user:self.user)
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


