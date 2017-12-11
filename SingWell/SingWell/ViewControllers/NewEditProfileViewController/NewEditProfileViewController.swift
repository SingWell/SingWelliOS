//
//  NewEditProfileViewController.swift
//  SingWell
//
//  Created by Elena Sharp on 12/10/17.
//  Copyright © 2017 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import IoniconsKit

class NewEditProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    let scrollView = UIScrollView()
    
    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var cameraButtonIcon: AnimatableButton!
    
    @IBOutlet weak var biographyImageView: AnimatableImageView!
    @IBOutlet weak var nameTextField: AnimatableTextField!
    @IBOutlet weak var biographyTextView: AnimatableTextView!
    @IBOutlet weak var phoneNumberTextField: AnimatableTextField!
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var cityTextField: AnimatableTextField!
    @IBOutlet weak var streetTextField: AnimatableTextField!
    @IBOutlet weak var stateTextField: AnimatableTextField!
    @IBOutlet weak var zipCodeTextField: AnimatableTextField!
    
    @IBOutlet weak var biographyView: AnimatableView!
    
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
    
    func setProfile() {
        
        var profileImage: UIImage = UIImage(named: "profileImage")!
        profileImage = profileImage.circleMasked!
        profileImageView.image = profileImage
        
        profileImageView.animate(.pop(repeatCount: 1))
        
        let profileBackgroundImage: UIImage = UIImage(named: "profileBackground")!
        profileBackgroundImageView.image = profileBackgroundImage
        
        let cameraIcon = UIImage.ionicon(with: .camera, textColor: UIColor.white, size: CGSize(width: 35, height: 35))
        cameraButtonIcon.setImage(cameraIcon, for: UIControlState.normal)
        
        let profileName = profileNamePassed
        
        nameTextField.text = profileName
        biographyTextView.text = biographyPassed
        if(biographyTextView.text == ""){
            biographyTextView.textColor = UIColor.lightGray
            biographyTextView.text = "Add a short biography here"
        }
        
        cityTextField.text = cityPassed
        
        streetTextField.text = streetPassed
        
        emailTextField.text = emailPassed
        
        phoneNumberTextField.text = phoneNumberPassed
        
        
    }
    
    func setIcons() {
        
        let nameIcon = UIImage.ionicon(with: .person, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
        
        nameTextField.leftImage = nameIcon
        nameTextField.leftImageLeftPadding = 10
        
        let bioIcon = UIImage.ionicon(with: .iosPaperOutline, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
        
        biographyImageView.image = bioIcon
        
        let emailIcon = UIImage.ionicon(with: .email, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
        
        emailTextField.leftImage = emailIcon
        emailTextField.leftImageLeftPadding = 10
        
        let phoneIcon = UIImage.ionicon(with: .iphone, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
        
        phoneNumberTextField.leftImage = phoneIcon
        phoneNumberTextField.leftImageLeftPadding = 10
        
        let cityIcon = UIImage.ionicon(with: .location, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
        
        cityTextField.leftImage = cityIcon
        cityTextField.leftImageLeftPadding = 10
        
        streetTextField.leftImage = cityIcon
        streetTextField.leftImageLeftPadding = 10
        
        stateTextField.leftImage = cityIcon
        stateTextField.leftImageLeftPadding = 10
        
        zipCodeTextField.leftImage = cityIcon
        zipCodeTextField.leftImageLeftPadding = 10
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        streetTextField.delegate = self
        cityTextField.delegate = self
        biographyTextView.delegate = self
        
        setCancelButton()
        setConfirmButton()
        setProfile()
        setIcons()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func keyboardWillShow(noti: Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextField) -> Bool {   //delegate method
        textView.resignFirstResponder()
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isBlank {
            textView.text = "Add a short biography here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        adjustUITextViewHeight(arg: biographyTextView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
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
