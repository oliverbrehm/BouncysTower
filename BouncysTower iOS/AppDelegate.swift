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
        NSLog("premium active: \(InAppPurchaseManager.shared.premiumPurchased)")
        InAppPurchaseManager.shared.requestProduct()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let vC = window?.rootViewController as? GameViewController, let game = vC.game {
            game.showPause()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data,
        // invalidate timers, and store enough application state information to restore your
        // application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called
        // instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state;
        // here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AudioManager.standard.checkMusicAfterReturningToApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
