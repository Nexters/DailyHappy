//
//  AppDelegate.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/29/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func bundlePath(path: String) -> String? {
        let resourcePath = NSBundle.mainBundle().resourcePath as NSString?
        return resourcePath?.stringByAppendingPathComponent(path)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // copy over old data files for migration
        let defaultPath = Realm.Configuration.defaultConfiguration.path!
        let defaultParentPath = (defaultPath as NSString).stringByDeletingLastPathComponent
        
        if let v0Path = bundlePath("default-v0.realm") {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(defaultPath)
                try NSFileManager.defaultManager().copyItemAtPath(v0Path, toPath: defaultPath)
            } catch {}
        }
        
        // define a migration block
        // you can define this inline, but we will reuse this to migrate realm files from multiple versions
        // to the most current version of our data model
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerate(Note.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        newObject?["memo"] = ""
                    }
                }
                migration.enumerate(Emotion.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        newObject?["emotionColorAlpha"] = 0.8
                    }
                }
            }
            print("Migration complete.")
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 3, migrationBlock: migrationBlock)
        return true
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

