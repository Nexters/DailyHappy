//
//  Emotion.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/29/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import Foundation
import RealmSwift

class Emotion: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var emotionName = ""
    dynamic var emotionColorRed:Float = 0.0
    dynamic var emotionColorGreen:Float = 0.0
    dynamic var emotionColorBlue:Float = 0.0
    
}
