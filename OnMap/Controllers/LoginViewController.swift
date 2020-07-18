//
//  LoginViewController.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/9/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    let signupEndpoint = Client.Endpoints.signup.url
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        buttonEnabled(true, button: loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - private methods
    
    func loggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.loginIndicator.startAnimating()
                self.buttonEnabled(false, button: self.loginButton)
            }
        } else {
            DispatchQueue.main.async {
                self.loginIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.loginButton)
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signupButton.isEnabled = !loggingIn
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        loggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.CompleteLogin, sender: nil)
            }
        } else {
            showAlert(message: "Please enter valid credentials.", title: "Login Error")
        }
    }
    

    // MARK: - IBActions
    
    @IBAction func login(_ sender: UIButton) {
        loggingIn(true)
        Client.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signup(_ sender: UIButton) {
        loggingIn(true)
        UIApplication.shared.open(signupEndpoint, options: [:], completionHandler: nil)
    }
}
