//
//  RegisterViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class RegisterViewController: BaseViewController {
    
    // MARK: - Coordinator methods
    var didRegister: () -> () = {}
    
    // MARK: - Private properties
    private var viewModel: RegisterViewModelProtocol
    private var registerView: RegisterView
    
    init(viewModel: RegisterViewModelProtocol, registerView: RegisterView = RegisterView()) {
        self.viewModel = viewModel
        self.registerView = registerView
        super.init(nibName: nil, bundle: nil)
        hideNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(registerView)
        setupBindig()
    }
    
    private func setupBindig() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        registerView.registerButton.onTap(disposeBag: disposeBag) { [weak self] in
            guard let name = self?.registerView.nameTextField.getText(), !name.isEmpty else {
                self?.registerView.nameTextField.isWarningEnabled(true)
                return
            }
            guard let email = self?.registerView.emailTextField.getText(), !email.isEmpty else {
                self?.registerView.emailTextField.isWarningEnabled(true)
                return
            }
            guard let password = self?.registerView.passwordTextField.getText(), !password.isEmpty else {
                self?.registerView.passwordTextField.isWarningEnabled(true)
                return
            }
            self?.viewModel.register(name: name, email: email, password: password)
        }
        registerView.loginButton.onTap(disposeBag: disposeBag) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        viewModel.onRegisterSuccessDriver
            .drive(onNext: { [weak self] isSuccessful in
                if isSuccessful {
                    self?.didRegister()
                }
            }).disposed(by: disposeBag)
    }
    
}
