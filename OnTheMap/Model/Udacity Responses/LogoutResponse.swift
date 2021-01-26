//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 25/01/21.
//

import Foundation

struct LogoutResponse: Codable {
    let session: LogoutSession
}

struct LogoutSession: Codable {
    let id: String
    let expiration: String
}
