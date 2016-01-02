//
//  EmotionMaker.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 1..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import Foundation
import UIKit


class EmotionMaker {
    
    enum Emotiontype {
        case Angry
        case Awesome
        case Confused
        case Flutter
        case Happy
        case Joy
        case Loved
        case Relaxed
        case Sad
        case Worried
        
        init() {
            self = .Angry
        }
    }
    
    private struct EmotionData {
        var type:Emotiontype
        var name:String
        var red:Float
        var green:Float
        var blue:Float
        var alpha:Float
        var cardicImagename:String
        var icImagename:String
        
        init(type: Emotiontype, name: String, red: Float, green:Float, blue:Float, alpha:Float, cardicImagename:String, icImagename:String ) {
            self.type = type
            self.name = name
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
            self.cardicImagename = cardicImagename
            self.icImagename = icImagename
        }
    }
   
    private var emotionDataset:[EmotionData]=[]
    
    
    
    init() {
       
        initEmotionDataset()
        
    }
    func initEmotionDataset() {
        emotionDataset.append(EmotionData(type: Emotiontype.Angry, name: "angry", red: 188.0/255, green: 59.0/255, blue: 59.0/255, alpha: 1.0, cardicImagename: "CardicAngry", icImagename: "angry"))
        emotionDataset.append(EmotionData(type: Emotiontype.Awesome, name: "awesome", red: 255.0/255, green: 128.0/255, blue: 8.0/255, alpha: 1.0, cardicImagename: "CardicAwesome", icImagename: "awesome"))
        emotionDataset.append(EmotionData(type: Emotiontype.Confused, name: "confused", red: 42.0/255, green:  8.0/255, blue: 69.0/255, alpha: 1.0, cardicImagename: "CardicConfused", icImagename: "confused"))
        emotionDataset.append(EmotionData(type: Emotiontype.Flutter, name: "flutter", red: 147.0/255, green: 249.0/255, blue: 185.0/255, alpha: 1.0, cardicImagename: "CardicFlutter", icImagename: "flutter"))
        emotionDataset.append(EmotionData(type: Emotiontype.Happy, name: "happy", red: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0, cardicImagename: "CardicHappy", icImagename: "happy"))
        emotionDataset.append(EmotionData(type: Emotiontype.Joy, name: "joy", red: 255.0/255, green: 200.0/255, blue: 55.0/255, alpha: 1.0, cardicImagename: "CardicJoy", icImagename: "joy"))
        emotionDataset.append(EmotionData(type: Emotiontype.Loved, name: "loved", red: 237.0/255, green: 90.0/255, blue: 90.0/255, alpha: 1.0, cardicImagename: "CardicLoved", icImagename: "loved"))
        emotionDataset.append(EmotionData(type: Emotiontype.Relaxed, name: "relaxed", red: 118.0/255, green: 184.0/255, blue: 82.0/255, alpha: 1.0, cardicImagename: "CardicRelaxed", icImagename: "relaxed"))
        emotionDataset.append(EmotionData(type: Emotiontype.Sad, name: "sad", red: 61.0/255, green: 114.0/255, blue: 180.0/255, alpha: 1.0, cardicImagename: "CardicSad", icImagename: "sad"))
        emotionDataset.append(EmotionData(type: Emotiontype.Worried, name: "worried", red: 175.0/255, green: 171.0/255, blue: 167.0/255, alpha: 1.0, cardicImagename: "CardicWorried", icImagename: "worried"))
    }
    
    func getEmotioninstance(type:Emotiontype) ->(Emotion) {
        for data in emotionDataset {
            if(data.type == type) {
                return Emotion(value: ["emotionName" : data.name, "emotionColorRed": data.red, "emotionColorGreen": data.green, "emotionColorBlue": data.red])
            }
        }
        return Emotion(value: ["emotionName" : "happy", "emotionColorRed": 155.0/255, "emotionColorGreen": 274.0/255, "emotionColorBlue": 274.0/255])
    }
    
    func getEmotionColor(name: String) ->(UIColor) {
        for data in emotionDataset {
            if(data.type == getEmotionType(name)) {
                return UIColor(colorLiteralRed: data.red, green: data.green, blue: data.blue, alpha: data.alpha)
            }
        }
        return UIColor(colorLiteralRed: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0)
    }
    
    func getEmotionColor(index: Int) ->(UIColor) {
        for data in emotionDataset {
            if(data.type == getEmotionType(index)) {
                return UIColor(colorLiteralRed: data.red, green: data.green, blue: data.blue, alpha: data.alpha)
            }
        }
        return UIColor(colorLiteralRed: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0)
    }
    
    func getEmotionColor(type:Emotiontype) ->(UIColor) {
        for data in emotionDataset {
            if(data.type == type) {
                return UIColor(colorLiteralRed: data.red, green: data.green, blue: data.blue, alpha: data.alpha)
            }
        }
        return UIColor(colorLiteralRed: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0)
    }
    
    func getCardicImagename(type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.cardicImagename
            }
        }
        return "CardicHappy"
    }
    
    func getIcImagename(type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.icImagename
            }
        }
        return "happy"
    }
    
    func getIcImagename(index: Int) ->(String) {
        for data in emotionDataset {
            if(data.type == getEmotionType(index)) {
                return data.icImagename
            }
        }
        return "happy"
    }
    
    func getEmotionType(emotionName:String) ->(Emotiontype){
        
        for data in emotionDataset {
            if(data.name == emotionName) {
                return data.type
            }
        }
        return Emotiontype.Happy
    }
    
    func getEmotionType(index:Int) ->(Emotiontype){
        return emotionDataset[index].type
    }
    
    func getEmotionName(index: Int) ->(String) {
        for data in emotionDataset {
            if(data.type == getEmotionType(index)) {
                return data.name
            }
        }
        return "happy"
    }
    
    func getEmotionCount() -> Int {
        return emotionDataset.count
    }
    
}