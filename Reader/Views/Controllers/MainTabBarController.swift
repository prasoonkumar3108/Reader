//
//  MainTabBarController.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let articlesVC = ArticlesViewController()
        let nav1 = UINavigationController(rootViewController: articlesVC)
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let bookmarksVC = BookmarkViewController()
        let nav2 = UINavigationController(rootViewController: bookmarksVC)
        nav2.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)

        viewControllers = [nav1, nav2]
    }
}

