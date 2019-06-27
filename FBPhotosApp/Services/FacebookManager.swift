//
//  FacebookManager.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/27/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import FBSDKLoginKit

enum FacebookManagerError: String,Error {
    case unknownError = "An error has occurred"
    case emptyData = "Error retrienving data"
    
    var description: String { return rawValue }
}

class FacebookManager {
    
    static let shared = FacebookManager()
    let loginManager = LoginManager()
    
    func SignIn(view: UIViewController, completion: @escaping (_ result: Result<Bool,FacebookManagerError>) -> Void) {
        loginManager.logIn(permissions: ["email","user_photos"], from: view, handler: { (result, error) -> Void in
            if error != nil {
                completion(.failure(.unknownError))
                return
            }
            
            guard let result = result else {
                completion(.failure(.emptyData))
                return
            }
            
            if result.grantedPermissions.contains("email") {
                completion(.success(true))
            }
        })
    }
    
    func SignOut() {
        if AccessToken.current != nil {
            loginManager.logOut()
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            UIApplication.setRootView(navController)
        }
    }
}
