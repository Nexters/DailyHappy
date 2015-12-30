//
//  Log.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/29/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    dynamic var emotion:Emotion?
    dynamic var hasPerson = false
    dynamic var hasItem = false
    dynamic var hasActivity = false
    dynamic var hasAnniversary = false
    dynamic var personName = ""
    dynamic var itemName = ""
    dynamic var activityName = ""
    dynamic var anniversaryName = ""
    dynamic var memo = ""
}
