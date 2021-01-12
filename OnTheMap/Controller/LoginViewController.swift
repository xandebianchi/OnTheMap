//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 10/01/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.getUdacitySignUpPage.url, options: [:], completionHandler: nil)
    }
    
}

