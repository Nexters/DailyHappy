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
        case Activity
        case Item
        case Anniversary
        case Person
        case Place
    }
    
    struct Color {
        static let lightGray = UIColor(red: 135.0/255, green: 135.0/255, blue: 135.0/255, alpha: 1.0)
    }
    
    struct Placeholder {
        static let MemoPlaceholder = "메모를 남겨주세요."
        static let Activity = "어떤 활동을 했었나요?"
        static let Item = "무엇과 관련이 있나요?"
        static let Anniversary = "무슨 날이었나요?"
        static let Person = "누가 떠오르나요?"
        static let Place = "어디에 있었나요?"
    }
    
}