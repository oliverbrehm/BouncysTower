//
//  AppDelegate.swift
//  BouncysTower iOS
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let vC = window?.rootViewController as? GameViewController, let game = vC.game {
            game.showPause()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AudioManager.standard.checkMusicAfterReturningToApp()
    }
}
