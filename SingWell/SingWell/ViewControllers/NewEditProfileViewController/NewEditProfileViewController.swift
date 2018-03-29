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
import ImageIO

protocol NewEditProfileDelegate: class {
    func sendInfo(_ bio: String?, _ phoneNumber: String?, _ city: String?, _ address: String?, _ zipCode: String?, _ state: String?, _ birthday: String?)
}

class NewEditProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    let scrollView = UIScrollView()
    
//    @IBOutlet weak var cameraButton: AnimatableButton!
    @IBOutlet weak var birthdayTextField: AnimatableTextField!
    
    //UIDatePicker
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var profileBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var birthdayIcon: AnimatableImageView!
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
    var statePassed = ""
    var zipPassed = ""
    var profileImagePassed = UIImage()
    var birthdayPassed = ""
    var newImage = UIImage()
    
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
    
    @IBAction func changePicture(_ sender: Any) {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @IBAction func birthdayEdit(_ sender: AnimatableTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let someDateTime = formatter.date(from: birthdayPassed)
        
        datePickerView.date = someDateTime!

        datePickerView.datePickerMode = UIDatePickerMode.date

        sender.inputView = datePickerView

        datePickerView.addTarget(self, action: #selector(NewEditProfileViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "MM-dd"
        
        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
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
        
        var profileImage: UIImage = userProfilePicture
        newImage = profileImagePassed
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
        
        stateTextField.text = statePassed
        
        zipCodeTextField.text = zipPassed
        
        emailTextField.text = emailPassed
        
        phoneNumberTextField.text = phoneNumberPassed
        
        birthdayTextField.text = birthdayPassed
        
        
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
    
    func setDate() {
        
        
        let dateIcon = UIImage.ionicon(with: .iosCalendarOutline, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
        
        birthdayTextField.leftImage = dateIcon
        birthdayTextField.leftImageLeftPadding = 10
    }
    
    @IBAction func DoneButton(sender: UIButton) {
        birthdayTextField.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show date picker
//        showDatePicker()
        
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        streetTextField.delegate = self
        cityTextField.delegate = self
        biographyTextView.delegate = self
        
        setCancelButton()
        setConfirmButton()
        setProfile()
        setIcons()
        setDate()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        editUser()
    }
    
    func editUser() {
        let delimiter = " "
        let fullName = nameTextField.text
        var name = fullName?.components(separatedBy: delimiter)
        let firstName = name![0]
        var lastName = ""
        if(name?.count == 2){
            lastName = name![1]
        }
        
        let phoneDelimiter = CharacterSet.init(charactersIn: "()-")
        let tmpNumber = phoneNumberTextField.text
        let phone = tmpNumber?.components(separatedBy: phoneDelimiter)
        var phoneNumber = ""
        for number in phone!{
            phoneNumber += number
        }
        let birthday = birthdayTextField.text
        
//        let email = emailTextField.text
        var biography = ""
        if(biographyTextView.text != "Add a short biography here"){
            biography = biographyTextView.text
        }
        let city = cityTextField.text
        let address = streetTextField.text
        let state = stateTextField.text
        let zipCode = zipCodeTextField.text
        
//        let parameters: [String: AnyObject] = [ "phone_number": phoneNumber as AnyObject, "address": address! as AnyObject, "bio": biography as AnyObject, "city": city! as AnyObject,"zip_code": zipCode! as AnyObject, "state": state! as AnyObject, "date_of_birth": "" as AnyObject]
        
        let parameters: [String: Any] = [ "profile": ["phone_number": phoneNumber, "address": address!, "bio": biography, "city": city!,"zip_code": zipCode!, "state": state!, "date_of_birth": birthday!], "last_name": lastName, "first_name":firstName]
        
        ApiHelper.editUser(parameters: parameters) { response, error in
            if error == nil {
                print("No error")
            } else {
                print(error!)
            }
        }
        
        ApiHelper.uploadImage(image: newImage, fileName: "profilePic") { response, error in
            if error == nil {
                print("No error")
            } else {
                print(error!)
            }
        }
        userProfilePicture = newImage
        
//        let nextVc = AppStoryboard.Profile.viewController(viewControllerClass: ProfileViewController) as! ProfileViewController
        
//        nextVc.biographyTextView.text = biography
//        nextVc.addressLabel.text = address
//        nextVc.birthdayLabel.text = birthday
//        nextVc.cityLabel.text = city
//        nextVc.phoneNumberButton.setTitle(phoneNumber, for: .normal)
//        nextVc.user["state"].string = state
//        nextVc.user["bio"].string = biography
//        nextVc.user["address"].string = address
//        nextVc.user["date_of_birth"].string = birthday
//        nextVc.user["city"].string = city
//        nextVc.user["phone_number"].string = phoneNumber
//        nextVc.user["zip_code"].string = zipCode
        
        
//        delegate.sendInfo()
        
        // do unwindToSaveProfileSegue
        self.performSegue(withIdentifier: "unwindToSaveProfileSegue", sender: self)
    }

    @IBAction func cancelUpdate(_ sender: Any) {
        
        self.performSegue(withIdentifier: "unwindToSaveProfileSegue", sender: self)
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

}

extension NewEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        
        let size = CGSize(width: 200, height:200)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = self.resizeImage(image: image, targetSize: size)
        newImage = image
        profileImageView.image = image
    }
    
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

