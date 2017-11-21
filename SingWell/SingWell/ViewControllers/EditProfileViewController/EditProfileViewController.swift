//
//  EditProfileViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 11/20/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import IBAnimatable
import IoniconsKit
import SwiftyJSON

class EditProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var nameLabel: AnimatableLabel!
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var biographyTextView: AnimatableTextView!
    
    
    @IBOutlet weak var instrumentationIcon: AnimatableImageView!
    @IBOutlet weak var addressIcon: AnimatableImageView!
    @IBOutlet weak var contactIcon: AnimatableImageView!
    @IBOutlet weak var biographyIcon: AnimatableImageView!
    
    
    @IBOutlet weak var cancelButtonImageView: AnimatableImageView!
    @IBOutlet weak var cancelButton: AnimatableButton!
    @IBOutlet weak var confirmButton: AnimatableButton!
    @IBOutlet weak var confirmButtonImageView: AnimatableImageView!
    
    var profileNamePassed = ""
    var biographyPassed = ""
    var phoneNumberPassed = ""
    var emailPassed = ""
    var streetPassed = ""
    var cityPassed = ""
    
    
    func setConfirmButton() {
        let size = CGSize(width:55, height: 55)
        var backImage: UIImage = UIImage(named: "confirmBackground")!
        backImage = backImage.resizeImageWith(newSize: size)
        backImage = backImage.circleMasked!
        confirmButtonImageView.image = backImage
        
        let confirmImage = UIImage.ionicon(with: .checkmarkRound, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        confirmButton.setImage( confirmImage, for: UIControlState.normal)
    }
    
    func setCancelButton() {
        let size = CGSize(width:55, height: 55)
        var backImage: UIImage = UIImage(named: "cancelBackground")!
        backImage = backImage.resizeImageWith(newSize: size)
        backImage = backImage.circleMasked!
        cancelButtonImageView.image = backImage
        
        let cancelImage = UIImage.ionicon(with: .closeRound, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
        cancelButton.setImage( cancelImage, for: UIControlState.normal)
    }
    
    func setIcons() {
        
        contactIcon.image = UIImage.ionicon(with: .chatbubble, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        biographyIcon.image = UIImage.ionicon(with: .person, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        addressIcon.image = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
        
        instrumentationIcon.image = UIImage.ionicon(with: .headphone, textColor: UIColor.gray, size: CGSize(width: 35, height: 35))
    }
    
    func setProfile() {
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        profileImageView.image = profileImage
        
        let profileBackgroundImage: UIImage = UIImage(named: "profileBackground")!
        profileBackgroundImageView.image = profileBackgroundImage
        
        var profileName = profileNamePassed
        
        nameLabel.text = profileName
        
        biographyTextView.text = biographyPassed
        biographyTextView.placeholderText = "Write a short biography here"
        cityTextField.text = cityPassed
        cityTextField.placeholder = "Dallas TX, 75206"
        streetTextField.text = streetPassed
        streetTextField.placeholder = "123 Abc Street"
        emailTextField.text = emailPassed
        emailTextField.placeholder = "example@gmail.com"
        phoneNumberTextField.text = phoneNumberPassed
        phoneNumberTextField.placeholder = "999-999-9999"
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        streetTextField.delegate = self
        cityTextField.delegate = self
        
        setCancelButton()
        setConfirmButton()
        setIcons()
        setProfile()


        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
//
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
//        return false
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setProfile()
//    }

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
