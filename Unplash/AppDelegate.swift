//
//  AppDelegate.swift
//  Unplash
//
//  Created by Ky Nguyen Coinhako on 4/24/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupApp()
        return true
    }
    
    func setupApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UINavigationController(rootViewController: HomeController())
        window!.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
}

