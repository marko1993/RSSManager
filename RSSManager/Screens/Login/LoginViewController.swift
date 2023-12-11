//
//  LoginViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Coordinator methods
    var didTapRegister: () -> () = {}
    var didSignIn: () -> () = {}
    
    // MARK: - Private properties
    private var viewModel: LoginViewModelProtocol
    private var loginView: LoginView
    
    init(viewModel: LoginViewModelProtocol, loginView: LoginView = LoginView()) {
        self.viewModel = viewModel
        self.loginView = loginView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(loginView)
        setupBindig()
    }
    
    private func setupBindig() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        loginView.registerButton.onTap(disposeBag: disposeBag) { [weak self] in
            self?.didTapRegister()
        }
        loginView.loginButton.onTap(disposeBag: disposeBag) { [weak self] in
            guard let email = self?.loginView.emailTextField.getText(), !email.isEmpty else {
                self?.loginView.emailTextField.isWarningEnabled(true)
                return
            }
            guard let password = self?.loginView.passwordTextField.getText(), !password.isEmpty else {
                self?.loginView.passwordTextField.isWarningEnabled(true)
                return
            }
            self?.viewModel.logIn(email: email, password: password)
        }
        viewModel.onLoginSuccessDriver
            .drive(onNext: { [weak self] isSuccessful in
                if isSuccessful {
                    self?.didSignIn()
                }
            }).disposed(by: disposeBag)
    }
    
}
