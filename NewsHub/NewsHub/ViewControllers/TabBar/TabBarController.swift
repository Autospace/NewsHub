//
//  TabBarController.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 18/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let home: HomeViewController = .instantiateFromStoryboard()
        home.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        let favorites: FavoritesViewController = .instantiateFromStoryboard()
        favorites.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let more: MoreViewController = .instantiateFromStoryboard()
        more.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        viewControllers = [
            UINavigationController(rootViewController: home),
            UINavigationController(rootViewController: favorites),
            UINavigationController(rootViewController: more)
        ]
    }
}
