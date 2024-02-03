
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let onboardingCompleted = UserDefaults.standard.bool(forKey: OnboardingPageViewController.onboardingCompletedKey)
        
        if !onboardingCompleted {
            
            let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            
            window.rootViewController = onboardingVC
        } else {
            let trackersViewController = TrackersViewController()
            trackersViewController.tabBarItem.image = UIImage(named: "TabBarTrackersIcon")
            trackersViewController.tabBarItem.title = NSLocalizedString("tabTrackers", comment: "")
            
            let statsViewController = StatisticViewController()
            statsViewController.tabBarItem.image = UIImage(named: "TabBarStatsIcon")
            statsViewController.tabBarItem.title = NSLocalizedString("tabStatistics", comment: "")
            
            let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
            
            let tabBarController = UITabBarController()
            let separatorImage = UIImage()
            tabBarController.tabBar.barTintColor = .ypBlack
            tabBarController.tabBar.shadowImage = separatorImage
            tabBarController.tabBar.backgroundImage = separatorImage
            tabBarController.tabBar.layer.borderWidth = 0.50
            tabBarController.tabBar.clipsToBounds = true
            
            tabBarController.viewControllers = [trackersNavigationController, statsViewController]
            window.rootViewController = tabBarController
        }
                
        self.window = window
        window.makeKeyAndVisible()
    }
}

