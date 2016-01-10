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
    
    enum Emotiontype: Int{
        case Angry = 0
        case Awesome = 1
        case Confused = 2
        case Flutter = 3
        case Happy = 4
        case Joy = 5
        case Loved = 6
        case Relaxed = 7
        case Sad = 8
        case Worried = 9
        
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
        var detailImagename:String
        var detailMent:String
        init(type: Emotiontype, name: String, red: Float, green:Float, blue:Float, alpha:Float, cardicImagename:String, icImagename:String, detailImagename:String, detailMent:String) {
            self.type = type
            self.name = name
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
            self.cardicImagename = cardicImagename
            self.icImagename = icImagename
            self.detailImagename = detailImagename
            self.detailMent = detailMent
        }
    }
   
    private var emotionDataset:[EmotionData]=[]
    
    
    
    init() {
       
        initEmotionDataset()
        
    }
    func initEmotionDataset() {
        emotionDataset.append(EmotionData(type: Emotiontype.Happy, name: "happy", red: 244.0/255, green: 135.0/255, blue: 137.0/255, alpha: 0.8, cardicImagename: "CardicHappy", icImagename: "happy" , detailImagename:"DetailHappy", detailMent: "행복해요"))
        emotionDataset.append(EmotionData(type: Emotiontype.Joy, name: "joy", red: 255.0/255, green: 118.0/255, blue: 0.0/255, alpha: 0.8, cardicImagename: "CardicJoy", icImagename: "joy" , detailImagename:"DetailJoy", detailMent: "즐거운 시간을 보냈어요"))
        emotionDataset.append(EmotionData(type: Emotiontype.Loved, name: "loved", red: 255.0/255, green: 65.0/255, blue: 75.0/255, alpha: 0.8, cardicImagename: "CardicLoved", icImagename: "loved", detailImagename:"DetailLoved", detailMent: "꺅 사랑에 빠졌어요"))
        emotionDataset.append(EmotionData(type: Emotiontype.Awesome, name: "awesome", red: 255.0/255, green: 202.0/255, blue: 10.0/255, alpha: 0.8, cardicImagename: "CardicAwesome", icImagename: "awesome" , detailImagename:"DetailAwesome", detailMent: "기억에 남을 멋진하루"))
        emotionDataset.append(EmotionData(type: Emotiontype.Flutter, name: "flutter", red: 114.0/255, green: 197.0/255, blue: 163.0/255, alpha: 0.8, cardicImagename: "CardicFlutter", icImagename: "flutter", detailImagename:"DetailFlutter", detailMent: "두근두근 설레이네요"))
         emotionDataset.append(EmotionData(type: Emotiontype.Relaxed, name: "relaxed", red: 98.0/255, green: 143.0/255, blue: 33.0/255, alpha: 0.8, cardicImagename: "CardicRelaxed", icImagename: "relaxed", detailImagename:"DetailRelaxed", detailMent: "평온한 일상"))
        emotionDataset.append(EmotionData(type: Emotiontype.Sad, name: "sad", red: 53.0/255, green: 109.0/255, blue: 183.0/255, alpha: 0.8, cardicImagename: "CardicSad", icImagename: "sad", detailImagename:"DetailSad", detailMent: "슬프네요"))
        emotionDataset.append(EmotionData(type: Emotiontype.Worried, name: "worried", red: 176.0/255, green: 171.0/255, blue: 167.0/255, alpha: 0.8, cardicImagename: "CardicWorried", icImagename: "worried", detailImagename:"DetailWorried", detailMent: "후우 걱정이 있어요"))
        emotionDataset.append(EmotionData(type: Emotiontype.Confused, name: "confused", red: 90.0/255, green:  42.0/255, blue: 108.0/255, alpha: 0.8, cardicImagename: "CardicConfused", icImagename: "confused", detailImagename:"DetailConfused", detailMent: "어떡해야 할까요"))
        emotionDataset.append(EmotionData(type: Emotiontype.Angry, name: "angry", red: 151.0/255, green: 48.0/255, blue: 55.0/255, alpha: 0.8, cardicImagename: "CardicAngry", icImagename: "angry", detailImagename:"DetailAngry", detailMent: "부들부들 화남"))

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
    
    func getDetailImagename(type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.detailImagename
            }
        }
        return "DetailHappy"
    }
    
    func getDetailMent(type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.detailMent
            }
        }
        return "행복해요"
    }

    func getDetailMent(index: Int) -> String {
        for data in emotionDataset {
            if data.type == getEmotionType(index) {
                return data.detailMent
            }
        }
        return "행복해요"
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
    
    func getEmotionIndex(emotionName: String) -> Int {
        return emotionDataset.indexOf({ (emotionData) -> Bool in
            return emotionData.name == emotionName
        })!
    }
}