//
//  LikedViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class LikedViewController: BaseViewController {
    
    private var viewModel: LikedViewModelProtocol
    private var likedView: LikedView
    
    init(viewModel: LikedViewModelProtocol, likedView: LikedView = LikedView()) {
        self.viewModel = viewModel
        self.likedView = likedView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(likedView)
    }
    
}
