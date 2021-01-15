//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 10/01/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = "alexandre.bianchi@ab-inbev.com"
        passwordTextField.text = "3Bossan3!@#"
    }

    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.getUdacitySignUpPage.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("Login successfull")
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            //showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
}

