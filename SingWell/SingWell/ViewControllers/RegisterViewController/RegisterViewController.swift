//
//  RegisterViewController.swift
//  SingWell
//
//  Created by Travis Siems on 1/30/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import DTTextField

var REGISTER_EMAIL = ""
var REGISTER_PASSWORD = ""

class RegisterViewController: AnimatableViewController {

    @IBOutlet weak var firstNameField: DTTextField!
    @IBOutlet weak var lastNameField: DTTextField!
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    
    @IBOutlet weak var loginButton: AnimatableButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        firstNameField.font = UIFont(name: DEFAULT_FONT, size: 20)
        lastNameField.font = UIFont(name: DEFAULT_FONT, size: 20)
        emailField.font = UIFont(name: DEFAULT_FONT, size: 20)
        passwordField.font = UIFont(name: DEFAULT_FONT, size: 20)
        loginButton.titleLabel?.font = UIFont(name: DEFAULT_FONT, size: 26)
    }

    @IBAction func signUpPressed(_ sender: Any) {
        guard validateData() else { return }
        
        // TODO: REGISTER USER
        ApiHelper.register(email: emailField.text!, firstname:firstNameField.text!, lastname: lastNameField.text!, password:  passwordField.text!) { response, error in
            
            print("RESPONSE REGISTER: ", response?.stringValue)
            print("Error register: ", error)
            if error == nil {
                // REGISTER SUCCESSFUL
//                let alert = UIAlertController(title: "Register Successful", message: response?.stringValue, preferredStyle: .alert)
//                alert.addAction( UIAlertAction(title: "OK", style: .cancel) )
//
//                self.present(alert, animated: true, completion: nil)
                REGISTER_EMAIL = self.emailField.text!
                REGISTER_PASSWORD = self.passwordField.text!
                
                self.performSegue(withIdentifier: "loginFromRegisterSegue", sender: self)
            } else {
                // REGISTER FAILED
                let alert = UIAlertController(title: "Register Failed", message: "", preferredStyle: .alert)
                alert.addAction( UIAlertAction(title: "OK", style: .cancel) )
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    let firstNameMessage        = "First Name is required."
    let lastNameMessage         = "Last Name is required."
    let emailMessage            = "Email is required."
    let passwordMessage         = "Password is required."
    
    func validateData() -> Bool {
        
        guard !firstNameField.text!.isEmptyStr else {
            firstNameField.showError(message: firstNameMessage)
            return false
        }
        
        guard !lastNameField.text!.isEmptyStr else {
            lastNameField.showError(message: lastNameMessage)
            return false
        }
        
        guard !emailField.text!.isEmptyStr else {
            emailField.showError(message: emailMessage)
            return false
        }
        
        guard !passwordField.text!.isEmptyStr else {
            passwordField.showError(message: passwordMessage)
            return false
        }
        
        
        
        return true
    }
    
    // MARK: Tap to hide
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
