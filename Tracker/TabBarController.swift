
import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: ""), image: UIImage(named: "trackersTabBar"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: ""), image: UIImage(named: "statisticsTabBar"), selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticsViewController]
        
        
    }
}
