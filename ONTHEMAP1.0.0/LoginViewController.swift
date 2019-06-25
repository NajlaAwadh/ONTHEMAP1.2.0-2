//
//  LoginViewController.swift
//  ONTHEMAP1.0.0
//
//  Created by Najla Awadh on 15/09/1440 AH.
//  Copyright © 1440 Najla Awadh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let username = emailTF.text
        let password = passwordTF.text
        
        if (username!.isEmpty) || (password!.isEmpty) {
            
            let requiredInfoAlert = UIAlertController (title: "Fill the required fields", message: "Please fill both the email and password", preferredStyle: .alert)
            
            requiredInfoAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            
            self.present (requiredInfoAlert, animated: true, completion: nil)
            
        } else {
            
            API.loginUdacity(username, password){(loginSuccess, key, error) in
            
                DispatchQueue.main.async {
                    
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                        
                        errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(errorAlert, animated: true, completion: nil)
                        return
                    }
                    
                    if !loginSuccess {
                        let loginAlert = UIAlertController(title: "Erorr logging in", message: "incorrect email or password", preferredStyle: .alert )
                        
                        loginAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(loginAlert, animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: "MapViewController", sender: nil)
                    
                }
                }}
        }
    }

}
