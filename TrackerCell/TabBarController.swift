//
//  TabBarController.swift
//  Tracker
//
//  Created by TATIANA VILDANOVA on 12.12.2023.
//

import Foundation

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
        
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerBar"),
            selectedImage: nil
        )
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticBar"),
            selectedImage: nil
        )
        
        let controllers = [trackersViewController, statisticsViewController]
        
        viewControllers = controllers
    }
}
