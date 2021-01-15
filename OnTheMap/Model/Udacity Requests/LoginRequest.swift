//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 11/01/21.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
    
    init(username: String, password: String) {
        self.udacity = Udacity(username: username, password: password)
    }
}

struct Udacity: Codable {
    let username: String
    let password: String
    
    init(username: String, password: String) {
       self.username = username
       self.password = password
    }
}
