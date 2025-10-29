//
//  ConfigureAppearance.swift
//  Reader
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import Foundation
import UIKit

final class ConfigureAppearance {
    static func apply() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor.background
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor.primary

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor.background
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
        UITabBar.appearance().tintColor = UIColor.primary

        UITableView.appearance().backgroundColor = UIColor.background
        UITableViewCell.appearance().backgroundColor = UIColor.secondaryBackground
        UITableView.appearance().separatorColor = UIColor.separator

        // status bar style will follow navigation bar and view controllers
    }
}
