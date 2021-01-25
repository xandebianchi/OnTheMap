//
//  PostLocation.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 23/01/21.
//

import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
