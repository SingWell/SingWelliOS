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
    
    //Format Phone Number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == phoneNumberTextField)
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }
    
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
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){
                
                if(self.count>=6 && self.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    
}
