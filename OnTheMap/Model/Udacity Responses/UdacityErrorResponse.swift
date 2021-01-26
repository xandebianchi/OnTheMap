//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 25/01/21.
//

import Foundation

struct UdacityErrorResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
