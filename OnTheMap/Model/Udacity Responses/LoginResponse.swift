//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 11/01/21.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: LoginSession
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct LoginSession: Codable {
    let id: String
    let expiration: String
}
