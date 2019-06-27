//
//  User.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/27/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation

enum UserError: String,Error {
    case noUser = "User email does not exist."
    case incorrectPassword = "Incorrect password."
    case alreadySignedUp = "You have already signed up."
    
    var description: String { return rawValue }
}

struct User {
    let email: String
    let password: String
}
