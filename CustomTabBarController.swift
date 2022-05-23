
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(red: 70/255, green: 146/255, blue: 250/255, alpha: 1)
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        navigationController.navigationBar.barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.barStyle = .black
        
        let requestViewController = FriendRequestViewController()
        let requestNavigationController = UINavigationController(rootViewController: requestViewController)
        requestNavigationController.title = "Requests"
        requestNavigationController.navigationBar.barStyle = .black
        requestNavigationController.navigationBar.barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        requestNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerViewController = UIViewController()
        messengerViewController.navigationItem.title = "Messenger"
        let messengerNavigationController = UINavigationController(rootViewController: messengerViewController)
        messengerNavigationController.title = "Messenger"
        messengerNavigationController.navigationBar.barStyle = .black
        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationViewController = UIViewController()
        notificationViewController.navigationItem.title = "Notification"
        let notificationNavigationController = UINavigationController(rootViewController: notificationViewController)
        notificationNavigationController.title = "Notification"
        notificationNavigationController.navigationBar.barStyle = .black
        notificationNavigationController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreViewController = UIViewController()
        moreViewController.navigationItem.title = "More"
        let moreNavigationController = UINavigationController(rootViewController: moreViewController)
        moreNavigationController.title = "More"
        moreNavigationController.navigationBar.barStyle = .black
        moreNavigationController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController, requestNavigationController, messengerNavigationController, notificationNavigationController, moreNavigationController]
        
        tabBar.isTranslucent = false
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = CGColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1)
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
        
    }
}
