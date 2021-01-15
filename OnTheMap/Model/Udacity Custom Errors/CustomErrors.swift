//
//  CustomErrors.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 12/01/21.
//

import Foundation

struct AppError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
