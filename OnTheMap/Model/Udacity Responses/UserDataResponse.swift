//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 23/01/21.
//

import Foundation

// MARK: - Welcome
struct UserDataResponse: Codable {
    let user: User
}

// MARK: - User
struct User: Codable {
    let firstName: String?
    let lastName: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
