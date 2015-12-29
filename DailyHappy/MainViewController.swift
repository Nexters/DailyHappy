//
//  ViewController.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/29/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class MainViewController: UIViewController {
    
    let realm = try! Realm()
    
    override func viewWillAppear(animated: Bool) {
        createEmotionTable()
        .subscribeNext { (Bool) -> Void in
            let emotions = self.realm.objects(Emotion)
            print(emotions)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createEmotionTable() -> Observable<Bool> {
        return create { observer in
            
            let emotions = self.realm.objects(Emotion)
            if emotions.count > 0 {
                try! self.realm.write {
                    self.realm.delete(emotions)
                }
            }
            // Realm Emotion table row 생성.
            
            let angry = Emotion(value: ["emotionName" : "angry", "emotionColorRed": 188, "emotionColorGreen": 59, "emotionColorBlue": 59])
            
            let joy = Emotion(value: ["emotionName" : "joy", "emotionColorRed": 255, "emotionColorGreen": 200, "emotionColorBlue": 55])
            
            let awesome = Emotion(value: ["emotionName" : "awesome", "emotionColorRed": 255, "emotionColorGreen": 128, "emotionColorBlue": 8])
            
            let flutter = Emotion(value: ["emotionName" : "fultter", "emotionColorRed": 147, "emotionColorGreen": 249, "emotionColorBlue": 185])
            
            let happy = Emotion(value: ["emotionName" : "happy", "emotionColorRed": 155, "emotionColorGreen": 274, "emotionColorBlue": 274])
            
            let loved = Emotion(value: ["emotionName" : "loved", "emotionColorRed": 237, "emotionColorGreen": 90, "emotionColorBlue": 90])
            
            let sad = Emotion(value: ["emotionName" : "sad", "emotionColorRed": 61, "emotionColorGreen": 114, "emotionColorBlue": 180])
            
            let relaxed = Emotion(value: ["emotionName" : "relaxed", "emotionColorRed": 118, "emotionColorGreen": 184, "emotionColorBlue": 82])
            
            let confused = Emotion(value: ["emotionName" : "confused", "emotionColorRed": 42, "emotionColorGreen": 8, "emotionColorBlue": 69])
            
            let worried = Emotion(value: ["emotionName" : "worried", "emotionColorRed": 175, "emotionColorGreen": 171, "emotionColorBlue": 167])
            
            try! self.realm.write {
                self.realm.add(angry)
                self.realm.add(joy)
                self.realm.add(awesome)
                self.realm.add(flutter)
                self.realm.add(happy)
                self.realm.add(loved)
                self.realm.add(sad)
                self.realm.add(relaxed)
                self.realm.add(confused)
                self.realm.add(worried)
            }

            observer.on(.Next(true))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
}

