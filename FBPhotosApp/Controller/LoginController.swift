//
//  LoginController.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import JGProgressHUD
import FBSDKLoginKit

class LoginController: UIViewController {
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 0.2965539384)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2978381849), for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleLogin() {
        handleTapDismiss()
        loginViewModel.performLogin { (result) in
            switch result {
            case .success:
                FacebookManager.shared.SignIn(view: self, completion: { (result) in
                    switch result {
                    case .success:
                        let albumListController = AlbumListController(collectionViewLayout: UICollectionViewFlowLayout())
                        let nav = UINavigationController(rootViewController: albumListController)
                        UIApplication.setRootView(nav)
                    case .failure(let error):
                        self.showHUDWithError(message: error.description)
                    }
                })
            case .failure(let error):
                self.showHUDWithError(message: error.description)
            }
        }
    }
    
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleGoToRegister), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoToRegister() {
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    fileprivate let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupTapGesture()
        setupBindables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)
        let bottomColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
    fileprivate func showHUDWithError(message: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Error!"
        hud.detailTextLabel.text = message
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1) : #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 0.2965539384)
        }
    }
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - verticalStackView.frame.origin.y - verticalStackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        let y = difference < 0 ? 0 : -difference - 8
        self.view.transform = CGAffineTransform(translationX: 0, y: y)
    }

}
