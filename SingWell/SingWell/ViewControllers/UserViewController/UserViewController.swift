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

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)

    }
    
    
    var userId = ""
    
    @IBOutlet weak var contactView: AnimatableView!
    @IBOutlet weak var biographyView: AnimatableView!
    @IBOutlet weak var addressView: AnimatableView!
    @IBOutlet weak var emailIcon: AnimatableImageView!
    @IBOutlet weak var birthdayView: AnimatableView!
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayIcon: AnimatableImageView!
    @IBOutlet weak var emailView: AnimatableView!
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
            let recipients:[String] = [phoneNumberButton.title(for: .normal)!]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = ""
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
            print("Text Msging not avaiable")
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
    
    func setEmailButton() {
        let size = CGSize(width:55, height: 55)
        var backImage: UIImage = UIImage(named: "editButtonBackground")!
        backImage = backImage.resizeImageWith(newSize: size)
        backImage = backImage.circleMasked!
        editImageView.image = backImage
        
        let editImage = UIImage.ionicon(with: .iosEmail, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        editButton.setImage( editImage, for: UIControlState.normal)
        editButton.addTarget(self, action: #selector(launchEmail(sender:)), for: .touchUpInside)
    }
    
    func setTextButton() {
        let size = CGSize(width:55, height: 55)
        var backImage: UIImage = UIImage(named: "editButtonBackground2")!
        backImage = backImage.resizeImageWith(newSize: size)
        backImage = backImage.circleMasked!
        notificationImageView.image = backImage
        
        let notificationImage = UIImage.ionicon(with: .iosTelephone, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        notificationButton.setImage( notificationImage, for: UIControlState.normal)
        notificationButton.addTarget(self, action: #selector(phoneNumberTap(_:)), for: .touchUpInside)
    }
    
    func setProfile(user:JSON) {
        
        if(user["profile"]["bio"].stringValue != ""){
            biographyView.isHidden = false
            biographyTextView.text = user["profile"]["bio"].stringValue
        }
        else{
            biographyView.isHidden = true
        }
        biographyTextView.font = UIFont(name: fontName, size: 17)
        
        if(user["profile"]["date_of_birth"].stringValue != ""){
            birthdayView.isHidden = false
            birthdayLabel.text = user["profile"]["date_of_birth"].stringValue
        }
        else{
            birthdayView.isHidden = true
        }
        birthdayLabel.font = UIFont(name: fontName, size: 17)
        
        if(user["email"].stringValue != ""){
            emailButton.setTitle(user["email"].stringValue, for: .normal)
            emailView.isHidden = false
            setEmailButton()
        }
        else {
            emailView.isHidden = true
        }
        
        if(user["profile"]["phone_number"].stringValue != ""){
            phoneNumberButton.setTitle(user["profile"]["phone_number"].stringValue, for: .normal)
//            phoneNumberButton.isHidden = false
            contactView.isHidden = false
            setTextButton()
        }
        else {
//            phoneNumberButton.setTitle("9999999999", for: .normal)
//            phoneNumberButton.titleLabel?.text = "9999999999"
//            phoneNumberButton.isHidden = true
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
        
//        var profileImage: UIImage = UIImage(named: "profileImage")!
//        profileImage = profileImage.circleMasked!
//        profileImageView.image = profileImage
        
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
    }
    
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileNameLabel: AnimatableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
        instrumentCollectionView.delegate = (self as UICollectionViewDelegate)
        instrumentCollectionView.dataSource = (self as UICollectionViewDataSource)
        
        self.title = "User Profile"
//        setEmailButton()
//        setTextButton()
        
        setInstrumentItems()
        setProfile(user: self.user)

        // Do any additional setup after loading the view.
        
        contactIcon.image = UIImage.ionicon(with: .iosTelephone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        emailIcon.image = UIImage.ionicon(with: .iosEmail, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        bioIcon.image = UIImage.ionicon(with: .iosPaperOutline, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        birthdayIcon.image = UIImage.ionicon(with: .iosCalendar, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        instrumentationButton.image = UIImage.ionicon(with: .headphone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUser() {
        let curUser = userId
        
        ApiHelper.getPicture(path: "pictures", id: curUser, type: "profile") { data, error in
            if error == nil {
                print(curUser)
                var decodedimage:UIImage
                let convertedData = Data(base64Encoded: data!)
                if(convertedData != nil){
                    decodedimage = UIImage(data: convertedData!)!
                }
                else {
                    decodedimage = UIImage(named: "profileImage")!
                }
                decodedimage = decodedimage.circleMasked!
                self.profileImageView.image = decodedimage
            } else {
                print("Error getting profilePic: ",error as Any)
            }
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


