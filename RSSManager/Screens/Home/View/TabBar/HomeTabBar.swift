//
//  HomeTabBar.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit
import RxSwift

protocol HomeTabBarViewDelegate: AnyObject {
    func didSelectTab(_ tabBar: HomeTabBar, at index: Int)
}

class HomeTabBar: UIView, BaseView {
    
    private lazy var tabContainer = UIView()
    private lazy var tabStackView = UIStackView()
    
    private var tabBarItems: [TabBarItem]
    private var tabBarItemViews: [TabBarItemView] = []
    private let disposeBag = DisposeBag()
    private var currentViewControllerIndex: Int = 0
    
    let tabBarHeight: CGFloat = 65.0
    
    weak var delegate: HomeTabBarViewDelegate?
    
    init(tabBarItems: [TabBarItem]) {
        self.tabBarItems = tabBarItems
        super.init(frame: .zero)
        setupView()
        setupTabs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabs() {
        for i in 0..<self.tabBarItems.count {
            let tabView = TabBarItemView(item: tabBarItems[i])
            tabBarItemViews.append(tabView)
            tabStackView.addArrangedSubview(tabView)
            tabView.onTap(disposeBag: disposeBag) { [weak self] in
                self?.onItemTap(tabView)
            }
        }
    }
    
    func addSubviews() {
        addSubview(tabContainer)
        addSubview(tabStackView)
    }
    
    func styleSubviews() {
        backgroundColor = .clear
        dropShadow()
        
        tabContainer.backgroundColor = .white
        tabContainer.layer.cornerRadius = 15
        tabContainer.layer.masksToBounds = true
        
        tabStackView.axis = .horizontal
        tabStackView.alignment = .fill
        tabStackView.contentMode = .scaleToFill
        tabStackView.distribution = .equalSpacing
        tabStackView.spacing = 0
        tabStackView.layer.cornerRadius = 30
    }
    
    func positionSubviews() {
        tabContainer.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        tabContainer.constrainHeight(tabBarHeight)
        
        tabStackView.anchor(leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 13))
        tabStackView.constrainHeight(tabBarHeight - 15)
        tabStackView.centerY(inView: tabContainer)
    }
    
    private func getViewControllersIndex(_ viewController: BaseViewController?) -> Int? {
        if viewController == nil { return nil }
        for i in 0..<tabBarItems.count {
            if tabBarItems[i].viewController == viewController {
                return tabBarItems[i].position
            }
        }
        return nil
    }
    
    private func onItemTap(_ view: TabBarItemView) {
        self.tabBarItemViews.forEach{$0.setIsSelected(isSelected: false)}
        view.setIsSelected(isSelected: true)
        delegate?.didSelectTab(self, at: view.getTabBarItem().position)
        self.currentViewControllerIndex = self.tabBarItemViews.firstIndex(where: { $0 === view }) ?? 0
    }
    
    func getViewController(index: Int) -> UIViewController? {
        if index < 0 || index >= tabBarItems.count { return nil }
        return self.tabBarItems[index].viewController
    }
    
    func getCurrentControllerIndex() -> Int {
        return currentViewControllerIndex
    }
    
}
