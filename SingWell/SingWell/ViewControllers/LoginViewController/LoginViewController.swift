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

class LoginViewController: AnimatableViewController {

    
    @IBOutlet weak var emailField: DTTextField!
    @IBOutlet weak var passwordField: DTTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        guard validateData() else { return }
        
        // TODO: LOGIN USER
        // TODO: CHECK IF LOGIN WORKED
        
        ApiHelper.login(emailField.text!, passwordField.text!) { response, error in
            
            print("RESPONSE LOGIN: ", response?.stringValue)
            print("Error login: ", error)
            if error == nil {
//                print
                // LOGIN SUCCESSFUL
                let alert = UIAlertController(title: "Login Successful", message: response?.stringValue, preferredStyle: .alert)
                alert.addAction( UIAlertAction(title: "OK", style: .cancel) )
                
                self.present(alert, animated: true, completion: nil)
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
}
