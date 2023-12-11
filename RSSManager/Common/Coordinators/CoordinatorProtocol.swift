//
//  CoordinatorProtocol.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit

protocol CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
    var currentViewController: UIViewController? { get set }
    var shouldEnd: () -> () {get set}
    
    func start()
}
