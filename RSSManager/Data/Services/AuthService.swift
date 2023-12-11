//
//  AuthService.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation
import FirebaseAuth
import RxSwift

protocol AuthServiceProtocol {
    func isUserLoggedIn() -> Bool
    func signIn(email: String, password: String) -> Observable<String>
    func register(name: String, email: String, password: String) -> Observable<User>
    func logUserOut() -> Observable<Bool>
}

class AuthService: AuthServiceProtocol {
    func logUserOut() -> Observable<Bool> {
        do {
            try Auth.auth().signOut()
            return Observable.just(true)
        } catch let error as NSError {
            return Observable.error(error)
        }
    }
    
    func register(name: String, email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    observer.onError(error)
                } else if let authResult = authResult {
                    let id = authResult.user.uid
                    observer.onNext(User(id: id, email: email, name: name))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func signIn(email: String, password: String) -> Observable<String> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    observer.onError(error)
                } else if let authResult = authResult {
                    observer.onNext(authResult.user.uid)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
}
