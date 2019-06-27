//
//  RegistrationController.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import JGProgressHUD
import FBSDKLoginKit

class RegistrationController: UIViewController {
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let confirmPasswordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Confirm password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 0.2965539384)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2978381849), for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    lazy var overallStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, confirmPasswordTextField, registerButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate let registrationViewModel = RegistrationViewModel()
    fileprivate let registeringHUD = JGProgressHUD(style: .dark)
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
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        
        let y = difference < 0 ? 0 : -difference - 8
        self.view.transform = CGAffineTransform(translationX: 0, y: y)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        switch textField {
        case emailTextField:
            registrationViewModel.email = textField.text
        case passwordTextField:
            registrationViewModel.password = textField.text
        case confirmPasswordTextField:
            registrationViewModel.confirmPassword = textField.text
        default:
            ()
        }
    }
    
    @objc fileprivate func handleRegister() {
        handleTapDismiss()
        registrationViewModel.performRegistration { (result) in
            switch result {
            case .success:
                FacebookManager.shared.SignIn(view: self, completion: { (result) in
                    switch result {
                    case .success:
                        let albumListController = AlbumListController(collectionViewLayout: UICollectionViewFlowLayout())
                        let nav = UINavigationController(rootViewController: albumListController)
                        UIApplication.setRootView(nav)
                    case .failure(let error):
                        self.showHUDWithError(message: error.localizedDescription)
                    }
                })
            case .failure:
                self.showHUDWithError(message: "You have already signed up.")
            }
        }
    }
    
    @objc func handleTapDismiss() {
        view.endEditing(true)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)
        let bottomColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func showHUDWithError(message: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Error!"
        hud.detailTextLabel.text = message
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
        registeringHUD.dismiss()
    }
    
    fileprivate func setupBindables() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1) : #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 0.2965539384)
        }
    }
}

