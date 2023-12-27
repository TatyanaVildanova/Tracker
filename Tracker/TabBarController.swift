
import UIKit

//MARK: - TabBarController Class

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        borderView.backgroundColor = UIColor.TrackerColor.gray
        tabBar.addSubview(borderView)
        
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage.TrackerIcon.records,
            tag: 0
        )
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage.TrackerIcon.statistics,
            tag: 1
        )
        
        self.viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
}
