//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 10/01/21.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - UIControls
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = "alexandre.bianchi@ab-inbev.com"
        passwordTextField.text = "3Bossan3!@#"
    }
    
    // MARK: - Actions

    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.getUdacitySignUpPage.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
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
