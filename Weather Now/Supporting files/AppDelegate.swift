//
//  AppDelegate.swift
//  Weather Now
//
//  Created by mac on 05.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = WeaterNowViewController()
        self.window?.makeKeyAndVisible()
        return true
    }
}
