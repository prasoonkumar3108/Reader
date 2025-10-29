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
        configureTabs()
    }

    private func configureTabs() {
        // Home Tab
        let articlesVC = ArticlesViewController()
        let nav1 = UINavigationController(rootViewController: articlesVC)
        nav1.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // Bookmarks Tab
        let bookmarksVC = BookmarkViewController()
        let nav2 = UINavigationController(rootViewController: bookmarksVC)
        nav2.tabBarItem = UITabBarItem(
            title: "Bookmarks",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )

        viewControllers = [nav1, nav2]
    }

    // Refresh appearance when system theme changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        ConfigureAppearance.apply()
    }
}


