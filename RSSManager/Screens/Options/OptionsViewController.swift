//
//  OptionsViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class OptionsViewController: BaseViewController {
    
    // MARK: - Coordinator methods
    var didLogOut: () -> () = {}
    
    private var viewModel: OptionsViewModelProtocol
    private var optionsView: OptionsView
    
    init(viewModel: OptionsViewModelProtocol, optionsView: OptionsView = OptionsView()) {
        self.viewModel = viewModel
        self.optionsView = optionsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(optionsView)
        setupBinding()
    }
    
    private func setupBinding() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        
        optionsView.notificationsSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(optionsView.notificationsSwitch.rx.isOn)
            .subscribe(onNext: { [weak self] isOn in
                self?.viewModel.enableNotifications(isOn)
            })
            .disposed(by: disposeBag)
        
        optionsView.logOutButton.onTap(disposeBag: disposeBag) { [weak self] in
            self?.viewModel.logOut()
        }
        
        viewModel.onLogOutSuccessDriver
            .drive(onNext: { [weak self] isSuccessful in
                if isSuccessful {
                    self?.didLogOut()
                }
            }).disposed(by: disposeBag)
    }
    
}
