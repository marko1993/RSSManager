//
//  UserService.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation
import FirebaseFirestore
import RxSwift

protocol UserServiceProtocol {
    func saveUser(_ user: User) -> Observable<User>
    func getCurrentUser() -> User?
    func fetchUserData(id: String) -> Observable<Bool>
    func clearCurrentUser()
}

class UserService {
    
    // MARK: - Private properties
    private var currentUser: User?
    private let collection: CollectionReference = Firestore.firestore().collection(K.Networking.Collections.users)
    
}

extension UserService: UserServiceProtocol {
    func clearCurrentUser() {
        currentUser = nil
    }
    
    func fetchUserData(id: String) -> Observable<Bool> {
        return Observable.create { observer in
            self.collection.document(id).getDocument { (document, error) in
                if let error = error {
                    observer.onError(error)
                } else if let document = document, document.exists {
                    if let data = document.data(),
                       let id = data["id"] as? String,
                       let email = data["email"] as? String,
                       let name = data["name"] as? String {
                        self.currentUser = User(id: id, email: email, name: name)
                        observer.onNext(true)
                        observer.onCompleted()
                    } else {
                        observer.onError(RxError.noElements)
                    }
                } else {
                    observer.onError(RxError.unknown)
                }
            }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func saveUser(_ user: User) -> Observable<User> {
        return Observable.create { observer in
            let userRef = self.collection.document(user.id)
            userRef.setData(["id": user.id,
                             "email": user.email,
                             "name": user.name]) { [weak self] error in
                if let error = error {
                    observer.onError(error)
                } else {
                    self?.currentUser = user
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
}
