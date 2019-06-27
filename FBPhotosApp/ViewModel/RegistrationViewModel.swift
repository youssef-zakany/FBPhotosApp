//
//  RegistrationViewModel.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import KeychainSwift

class RegistrationViewModel {
    let keychain = KeychainSwift()
    var bindableIsFormValid = Bindable<Bool>()
    
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    var confirmPassword: String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && email?.isValidEmail() == true && password?.isEmpty == false && confirmPassword?.isEmpty == false && password == confirmPassword
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (_ result: Result<Bool,Error>) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        
        let user = User(email: email, password: password)
        
        if let emailKey = keychain.get("email"), user.email == emailKey {
            completion(.failure(UserError.alreadySignedUp))
            return
        }
        
        keychain.set(email, forKey: "email")
        keychain.set(password, forKey: "password")
        
        completion(.success(true))
    }
}

