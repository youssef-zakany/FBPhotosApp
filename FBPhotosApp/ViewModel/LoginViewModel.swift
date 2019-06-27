//
//  LoginViewModel.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import KeychainSwift

class LoginViewModel {
    let keychain = KeychainSwift()
    
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && email?.isValidEmail() == true && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping (_ result: Result<Bool,UserError>) -> ()) {
        guard let email = email, let password = password else { return }
        //isLoggingIn.value = true
        
        let user = User(email: email, password: password)
        let emailKey = keychain.get("email")
        let passwordKey = keychain.get("password")
        
        if user.email == emailKey && user.password == passwordKey {
            completion(.success(true))
        } else if user.email != emailKey {
            completion(.failure(UserError.noUser))
        } else {
            completion(.failure(UserError.incorrectPassword))
        }
    }
}

