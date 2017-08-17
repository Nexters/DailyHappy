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

    func bundlePath(_ path: String) -> String? {
        let resourcePath = Bundle.main.resourcePath as NSString?
        return resourcePath?.appendingPathComponent(path)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // copy over old data files for migration
        let config = Realm.Configuration(
            schemaVersion: 7,
        // define a migration block
        // you can define this inline, but we will reuse this to migrate realm files from multiple versions
        // to the most current version of our data model
            migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Note.className()) { _, newObject in
                        newObject?["memo"] = ""
                }
                migration.enumerateObjects(ofType: Emotion.className()) { _, newObject in
                        newObject?["emotionColorAlpha"] = 0.8
                }
            } else if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: Note.className()) { _, newObject in
                        newObject?["hasMemo"] = false
                }
            } else if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: Note.className()) { oldObject, newObject in
                        let hasMemo = oldObject!["hasMemo"] as! Bool
                        newObject!["hasPlace"] = hasMemo
                        newObject?["placeName"] = ""
                }
            } else if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Note.className()) { _, newObject in
                        newObject?["date"] = NSDate()
                }
            } else if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: Note.className()) { oldObject, newObject in
                        let emotion = oldObject!["emotion"] as! Emotion
                        newObject!["emotion"] = emotion.emotionName
                }
            } else if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: Note.className()) { _, newObject in
                        newObject?["id"] = 0
                }
            } else if oldSchemaVersion < 7 {
                migration.enumerateObjects(ofType: Note.className()) { oldObject, newObject in
                        let id = oldObject!["id"] as! Int
                        newObject!["id"] = id
                }
            }
            print("Migration complete.")
        })
        
        Realm.Configuration.defaultConfiguration = config
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

