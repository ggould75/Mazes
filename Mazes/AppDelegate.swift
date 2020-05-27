//
//  AppDelegate.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let arguments = ProcessInfo.processInfo.arguments
        let ignoreUserDefaults = arguments.contains("uitest-environment")

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(shouldIgnoreUserDefaults: ignoreUserDefaults)
        window?.makeKeyAndVisible()

        return true
    }
}

