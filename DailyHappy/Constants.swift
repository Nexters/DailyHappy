//
//  Constants.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/29/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    enum Emotion: String {
        case Angry = "angry"
        case Joy = "joy"
        case Awesome = "awesome"
        case Flutter = "flutter"
        case Happy = "happy"
        case Loved = "loved"
        case Sad = "sad"
        case Confused = "confused"
        case Worried = "worried"
    }
    
    enum Keyword {
        case activity
        case item
        case anniversary
        case person
        case place
    }
    
    struct Color {
        static let lightGray = UIColor(red: 135.0/255, green: 135.0/255, blue: 135.0/255, alpha: 1.0)
    }
    
    struct Placeholder {
        static let MemoPlaceholder = NSLocalizedString("memo_hint", comment: "A hint message for memo")
        static let Activity = NSLocalizedString("activity_hint", comment: "A hint message for activity keyword.")
        static let Item = NSLocalizedString("item_hint", comment: "A hint message for item keyword.")
        static let Anniversary = NSLocalizedString("anniversary_hint", comment: "A hint message for anniversary keyword.")
        static let Person = NSLocalizedString("person_hint", comment: "A hint message for person keyword")
        static let Place = NSLocalizedString("place_hint", comment: "A hint message for place keyword.")
    }
    
}
