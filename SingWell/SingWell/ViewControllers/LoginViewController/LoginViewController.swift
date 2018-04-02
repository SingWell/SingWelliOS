//
//  LoginViewController.swift
//  SingWell
//
//  Created by Travis Siems on 1/30/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import DTTextField
//import CoreAudio
import AVFoundation
import CoreMIDI
import AudioToolbox

//import AudioKit
//import AudioKitUI

class LoginViewController: AnimatableViewController {

    
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionAnimationType = .fade(direction: .cross)
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        guard validateData() else { return }
        
        // TODO: LOGIN USER
        
        ApiHelper.login(emailField.text!, passwordField.text!) { response, error in
            
            print("RESPONSE LOGIN: ", response?.dictionary)
            print("Error login: ", error)
            if error == nil && response?.dictionary!["token"] != nil {
                
                // LOGIN SUCCESSFUL
                let nextVc = AppStoryboard.SideMenu.initialViewController()
                self.present(nextVc!, animated: true)
//                let animator = FadeAnimator(direction: .cross, duration: 0.4)
//                animator.animateTransition(using: self)
            } else {
                // LOGIN FAILED
                let alert = UIAlertController(title: "Login Failed", message: "Your email and password were not recognized.", preferredStyle: .alert)
                alert.addAction( UIAlertAction(title: "OK", style: .cancel) )
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let nextVc = AppStoryboard.Register.initialViewController() as! RegisterViewController
        self.present(nextVc, animated: true)
//        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        self.passwordField.text = ""
    }
    
    @IBAction func loginFromRegister(_ sender: UIStoryboardSegue) {
        self.emailField.text = REGISTER_EMAIL
        self.passwordField.text = REGISTER_PASSWORD
    }
    
    
    
    
    let emailMessage            = "Email is required."
    let passwordMessage         = "Password is required."
    
    func validateData() -> Bool {
        
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

