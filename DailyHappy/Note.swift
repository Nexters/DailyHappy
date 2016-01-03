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
    dynamic var id = 0
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    dynamic var date = NSDate()
    dynamic var emotion = ""
    dynamic var hasPerson = false
    dynamic var hasItem = false
    dynamic var hasActivity = false
    dynamic var hasAnniversary = false
    dynamic var hasPlace = false
    dynamic var personName = ""
    dynamic var itemName = ""
    dynamic var activityName = ""
    dynamic var anniversaryName = ""
    dynamic var placeName = ""
    dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //Incremente ID
    static func incrementeID() -> Int{
        let realm = try! Realm()
        let notes = realm.objects(Note)
        let lastNote = notes.last
        if notes.count > 0 {
            let lastId = lastNote?.id
            return lastId! + 1
        } else {
            return 1
        }
    }
}
