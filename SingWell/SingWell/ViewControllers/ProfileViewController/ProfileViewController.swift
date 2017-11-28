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
        
        emailLabel.text = "example@gmail.com"
        phoneNumberLabel.text = "(999)999-9999"
        addressLabel.text = "123 ABC Street"
        cityLabel.text = "Dallas, TX 25206"
        
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
        
        bioIcon.image = UIImage.ionicon(with: .person, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        instrumentationButton.image = UIImage.ionicon(with: .headphone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editProfile(_ sender: Any) {
    
        let nextVc = AppStoryboard.EditProfile.initialViewController() as! EditProfileViewController
        
        nextVc.profileNamePassed = profileNameLabel.text!
        nextVc.biographyPassed = biographyTextView.text!
        nextVc.cityPassed = cityLabel.text!
        nextVc.streetPassed = addressLabel.text!
        nextVc.emailPassed = emailLabel.text!
        nextVc.phoneNumberPassed = phoneNumberLabel.text!
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    
    }
    
    func getUser() {
        ApiHelper.getUser(userId: "1") { response, error in
            if error == nil {
                self.user = response!
                
                self.reloadView()
            } else {
                print(error!)
            }
        }
    }
    
    func reloadView() {
        var profileName = ""
        if(self.user != []){
            profileName = self.user["username"].stringValue
        }
        
        profileNameLabel.text = profileName

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


