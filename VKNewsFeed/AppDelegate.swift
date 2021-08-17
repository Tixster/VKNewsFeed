//
//  AppDelegate.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 14.08.2021.
//

import UIKit
import VK_ios_sdk

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var authService: AuthService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = AuthViewController()
        authService = AuthService.shared
        authService.delegate = self
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        return true
    }


}

//MARK: - AuthServiceDelegate
extension AppDelegate: AuthServiceDelegate {
    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print(#function)
        let feedVC = NewsFeedViewController()
        let navVC = UINavigationController(rootViewController: feedVC)
        window?.rootViewController = navVC
    }
    
    func authServiceSignInFail() {
        print(#function)
    }
    
    
}
