//
//  AppDelegate.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        TwitterAPICaller.client?.handleOpenUrl(url: url)
        
        return true
        
    }
    
}
