//
//  AppDelegate.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.appCoordinator = AppCoordinator(onWindow: window!)
        appCoordinator.start()
        
        return true
    }

}
