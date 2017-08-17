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
        case angry = 0
        case awesome = 1
        case confused = 2
        case flutter = 3
        case happy = 4
        case joy = 5
        case loved = 6
        case relaxed = 7
        case sad = 8
        case worried = 9
        
        init() {
            self = .angry
        }
    }
    
    fileprivate struct EmotionData {
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
   
    fileprivate var emotionDataset:[EmotionData]=[]
    
    
    
    init() {
       
        initEmotionDataset()
        
    }
    func initEmotionDataset() {
        emotionDataset.append(EmotionData(type: Emotiontype.happy, name: "happy", red: 244.0/255, green: 135.0/255, blue: 137.0/255, alpha: 0.8, cardicImagename: "CardicHappy", icImagename: "happy" , detailImagename:"DetailHappy", detailMent: NSLocalizedString("happy", comment: "Description for happiness")))
        emotionDataset.append(EmotionData(type: Emotiontype.joy, name: "joy", red: 255.0/255, green: 118.0/255, blue: 0.0/255, alpha: 0.8, cardicImagename: "CardicJoy", icImagename: "joy" , detailImagename:"DetailJoy", detailMent: NSLocalizedString("joy", comment: "Descriotion for joy")))
        emotionDataset.append(EmotionData(type: Emotiontype.loved, name: "loved", red: 255.0/255, green: 65.0/255, blue: 75.0/255, alpha: 0.8, cardicImagename: "CardicLoved", icImagename: "loved", detailImagename:"DetailLoved", detailMent: NSLocalizedString("in_love", comment: "Description fo in love")))
        emotionDataset.append(EmotionData(type: Emotiontype.awesome, name: "awesome", red: 255.0/255, green: 202.0/255, blue: 10.0/255, alpha: 0.8, cardicImagename: "CardicAwesome", icImagename: "awesome" , detailImagename:"DetailAwesome", detailMent: NSLocalizedString("awesome", comment: "Description for awesome")))
        emotionDataset.append(EmotionData(type: Emotiontype.flutter, name: "flutter", red: 114.0/255, green: 197.0/255, blue: 163.0/255, alpha: 0.8, cardicImagename: "CardicFlutter", icImagename: "flutter", detailImagename:"DetailFlutter", detailMent: NSLocalizedString("looking_foward", comment: "Desription for looking forward")))
         emotionDataset.append(EmotionData(type: Emotiontype.relaxed, name: "relaxed", red: 98.0/255, green: 143.0/255, blue: 33.0/255, alpha: 0.8, cardicImagename: "CardicRelaxed", icImagename: "relaxed", detailImagename:"DetailRelaxed", detailMent: NSLocalizedString("peaceful", comment: "Description for peaceful")))
        emotionDataset.append(EmotionData(type: Emotiontype.sad, name: "sad", red: 53.0/255, green: 109.0/255, blue: 183.0/255, alpha: 0.8, cardicImagename: "CardicSad", icImagename: "sad", detailImagename:"DetailSad", detailMent: NSLocalizedString("sad", comment: "Description for sadness")))
        emotionDataset.append(EmotionData(type: Emotiontype.worried, name: "worried", red: 176.0/255, green: 171.0/255, blue: 167.0/255, alpha: 0.8, cardicImagename: "CardicWorried", icImagename: "worried", detailImagename:"DetailWorried", detailMent: NSLocalizedString("worried", comment: "Description for worried")))
        emotionDataset.append(EmotionData(type: Emotiontype.confused, name: "confused", red: 90.0/255, green:  42.0/255, blue: 108.0/255, alpha: 0.8, cardicImagename: "CardicConfused", icImagename: "confused", detailImagename:"DetailConfused", detailMent: NSLocalizedString("confused", comment: "Description for confused")))
        emotionDataset.append(EmotionData(type: Emotiontype.angry, name: "angry", red: 151.0/255, green: 48.0/255, blue: 55.0/255, alpha: 0.8, cardicImagename: "CardicAngry", icImagename: "angry", detailImagename:"DetailAngry", detailMent: NSLocalizedString("angry", comment: "Description for angry")))

    }
    
    func getEmotioninstance(_ type:Emotiontype) ->(Emotion) {
        for data in emotionDataset {
            if(data.type == type) {
                return Emotion(value: ["emotionName" : data.name, "emotionColorRed": data.red, "emotionColorGreen": data.green, "emotionColorBlue": data.red])
            }
        }
        return Emotion(value: ["emotionName" : "happy", "emotionColorRed": 155.0/255, "emotionColorGreen": 274.0/255, "emotionColorBlue": 274.0/255])
    }
    
    func getEmotionColor(_ name: String) ->(UIColor) {
        for data in emotionDataset {
            if(data.type == getEmotionType(name)) {
                return UIColor(colorLiteralRed: data.red, green: data.green, blue: data.blue, alpha: data.alpha)
            }
        }
        return UIColor(colorLiteralRed: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0)
    }
    
    func getEmotionColor(_ index: Int) ->(UIColor) {
        for data in emotionDataset {
            if(data.type == getEmotionType(index)) {
                return UIColor(colorLiteralRed: data.red, green: data.green, blue: data.blue, alpha: data.alpha)
            }
        }
        return UIColor(colorLiteralRed: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0)
    }
    
    func getEmotionColor(_ type:Emotiontype) ->(UIColor) {
        for data in emotionDataset {
            if(data.type == type) {
                return UIColor(colorLiteralRed: data.red, green: data.green, blue: data.blue, alpha: data.alpha)
            }
        }
        return UIColor(colorLiteralRed: 155.0/255, green: 274.0/255, blue: 274.0/255, alpha: 1.0)
    }
    
    func getCardicImagename(_ type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.cardicImagename
            }
        }
        return "CardicHappy"
    }
    
    func getDetailImagename(_ type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.detailImagename
            }
        }
        return "DetailHappy"
    }
    
    func getDetailMent(_ type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.detailMent
            }
        }
        return "행복해요"
    }

    func getDetailMent(_ index: Int) -> String {
        for data in emotionDataset {
            if data.type == getEmotionType(index) {
                return data.detailMent
            }
        }
        return "행복해요"
    }

    func getIcImagename(_ type:Emotiontype) ->(String) {
        for data in emotionDataset {
            if(data.type == type) {
                return data.icImagename
            }
        }
        return "happy"
    }
    
    func getIcImagename(_ index: Int) ->(String) {
        for data in emotionDataset {
            if(data.type == getEmotionType(index)) {
                return data.icImagename
            }
        }
        return "happy"
    }
    
    func getEmotionType(_ emotionName:String) ->(Emotiontype){
        
        for data in emotionDataset {
            if(data.name == emotionName) {
                return data.type
            }
        }
        return Emotiontype.happy
    }
    
    func getEmotionType(_ index:Int) ->(Emotiontype){
        return emotionDataset[index].type
    }
    
    func getEmotionName(_ index: Int) ->(String) {
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
    
    func getEmotionIndex(_ emotionName: String) -> Int {
        return emotionDataset.index(where: { (emotionData) -> Bool in
            return emotionData.name == emotionName
        })!
    }
}
