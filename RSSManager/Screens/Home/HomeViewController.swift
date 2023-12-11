//
//  HomeViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit
import RxSwift

class HomeViewController: UIPageViewController {
    
    var homeTabBar: HomeTabBar!
    var viewModel: HomeViewModelProtocol
    let disposeBag = DisposeBag()
    private let tabBarItems: [TabBarItem]
    
    init(viewModel: HomeViewModelProtocol!, tabBarItems: [TabBarItem]) {
        self.viewModel = viewModel
        self.tabBarItems = tabBarItems
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTabBar()
    }
    
    func configureTabBar() {
        homeTabBar = HomeTabBar(tabBarItems: tabBarItems)
        homeTabBar.delegate = self
        
        view.addSubview(homeTabBar)
        homeTabBar.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        homeTabBar.constrainHeight(homeTabBar.tabBarHeight)
        if let vc = homeTabBar.getViewController(index: 0) {
            self.setViewControllers([vc], direction: .forward, animated: true)
        }
    }
 
}

extension HomeViewController: HomeTabBarViewDelegate {
    func didSelectTab(_ tabBar: HomeTabBar, at index: Int) {
        if let vc = homeTabBar.getViewController(index: index) {
            if index < homeTabBar.getCurrentControllerIndex() {
                setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
            } else {
                setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            }
        }
    }
}

