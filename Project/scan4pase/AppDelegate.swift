//
//  AppDelegate.swift
//  scan4pase
//
//  Created by Dhruv Sringari on 7/4/16.
//  Copyright © 2016 Dhruv Sringari. All rights reserved.
//

import UIKit
import MagicalRecord
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Start the Magic
        MagicalRecord.setLoggingLevel(.Warn)
        MagicalRecord.setupAutoMigratingCoreDataStack()
        FIRApp.configure()
        
        let appDefaults = ["taxPercentage": NSNumber(int: 6), "creditCardFeePercentage": NSNumber(int: 3)]
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        
        // Tab Bar Appearance
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 43, green: 130, blue: 201)], forState: .Selected)
        
        registerForPushNotifications(application)
        
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == .Inactive || application.applicationState == .Background {
            
        } else {
            let notification = UILocalNotification()
            if let aps = userInfo["aps"] {
                notification.alertTitle = aps["alert"] as? String
            }
            notification.soundName = UILocalNotificationDefaultSoundName
            application.presentLocalNotificationNow(notification)
        }
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("Device Token:", tokenString)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
