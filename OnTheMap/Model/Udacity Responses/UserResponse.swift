//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 23/01/21.
//

import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
