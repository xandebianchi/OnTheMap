//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 10/01/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UIControls
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
       
    // MARK: - Properties
    
    var keyboardIsVisible = false
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Actions

    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.getUdacitySignUpPage.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    // MARK: - Functions related to keyboard presentation
    
    // Function called when keyboard must be shown and the screen must be moved up
    @objc func keyboardWillShow(_ notification:Notification) {
        if !keyboardIsVisible && (emailTextField.isEditing || passwordTextField.isEditing) {
            view.frame.origin.y -= loginButton.frame.height
            keyboardIsVisible = true
        }
    }
    
    // Function called when screen must be moved down
    @objc func keyboardWillHide(_ notification:Notification) {
        if keyboardIsVisible {
            view.frame.origin.y += loginButton.frame.height
            keyboardIsVisible = false
        }
    }
    
    // MARK: - Subscribe and unsubscribe from keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Text field delegate functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - Main methods
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showFailure(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
