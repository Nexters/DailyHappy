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

class MainViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var WriteButton: MKButton!
    
    var realm:Realm?
    
    override func viewWillAppear(animated: Bool) {
        realm = try! Realm()
        createEmotionTable()
        .subscribeNext { (Bool) -> Void in
            //let emotions = self.realm.objects(Emotion)
            //print(emotions)
        }
        createDummyNote()
    }
    
    @IBAction func ShowWriteView(sender: AnyObject) {
        let WriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("WriteVC") as! WriteNoteViewController
        
        self.presentViewController(WriteVC, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()//UIColor(white: 1, alpha:0)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell") as! MainTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        
        
        
        //cell.TestLabel.text = "dsfsdfa"
        return cell
        
        //let cell: TestTableViewCell = TestTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TestTableVIewCell")
        //cell.TestLabel.text = "asdasd"
        //return cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("TestTableVIewCell", forIndexPath: indexPath) as! TestTableViewCell
        
        // 셀의 데이터와 이미지 설정 코드
        //let row = indexPath.row
        //cell.TestLabel.text = "asdasd"
        
        
        //return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
        
        
        WriteButton.cornerRadius = 10.0
        WriteButton.backgroundLayerCornerRadius = 10.0
        WriteButton.maskEnabled = false
        WriteButton.ripplePercent = 1.75
        WriteButton.rippleLocation = .Center
        
        WriteButton.layer.shadowOpacity = 0.75
        WriteButton.layer.shadowRadius = 3.5
        WriteButton.layer.shadowColor = UIColor.blackColor().CGColor
        WriteButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRealm() -> Realm {
        return self.realm!
    }
    
    func createEmotionTable() -> Observable<Bool> {
        return create { observer in
            
            let emotions = self.realm!.objects(Emotion)
            if emotions.count > 0 {
                try! self.realm!.write {
                    self.realm!.delete(emotions)
                }
            }
            // Realm Emotion table row 생성.
            
            let angry = Emotion(value: ["emotionName" : "angry", "emotionColorRed": 188, "emotionColorGreen": 59, "emotionColorBlue": 59])
            let joy = Emotion(value: ["emotionName" : "joy", "emotionColorRed": 255, "emotionColorGreen": 200, "emotionColorBlue": 55])
            let awesome = Emotion(value: ["emotionName" : "awesome", "emotionColorRed": 255, "emotionColorGreen": 128, "emotionColorBlue": 8])
            let flutter = Emotion(value: ["emotionName" : "flutter", "emotionColorRed": 147, "emotionColorGreen": 249, "emotionColorBlue": 185])
            let happy = Emotion(value: ["emotionName" : "happy", "emotionColorRed": 155, "emotionColorGreen": 274, "emotionColorBlue": 274])
            let loved = Emotion(value: ["emotionName" : "loved", "emotionColorRed": 237, "emotionColorGreen": 90, "emotionColorBlue": 90])
            let sad = Emotion(value: ["emotionName" : "sad", "emotionColorRed": 61, "emotionColorGreen": 114, "emotionColorBlue": 180])
            let relaxed = Emotion(value: ["emotionName" : "relaxed", "emotionColorRed": 118, "emotionColorGreen": 184, "emotionColorBlue": 82])
            let confused = Emotion(value: ["emotionName" : "confused", "emotionColorRed": 42, "emotionColorGreen": 8, "emotionColorBlue": 69])
            let worried = Emotion(value: ["emotionName" : "worried", "emotionColorRed": 175, "emotionColorGreen": 171, "emotionColorBlue": 167])
            
            try! self.realm!.write {
                self.realm!.add(angry)
                self.realm!.add(joy)
                self.realm!.add(awesome)
                self.realm!.add(flutter)
                self.realm!.add(happy)
                self.realm!.add(loved)
                self.realm!.add(sad)
                self.realm!.add(relaxed)
                self.realm!.add(confused)
                self.realm!.add(worried)
            }

            observer.on(.Next(true))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    func createDummyNote() {
        let notes = self.realm!.objects(Note)
        if notes.count > 0 {
            self.realm!.delete(notes)
        }
        
        let now = NSDate()
        
        for i in 0..<5 {
            let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: now, options: NSCalendarOptions.init(rawValue: 0))
            let note = Note()
            note.createdAt = calculatedDate!
            note.updatedAt = calculatedDate!
            let happys = self.realm!.objects(Emotion).filter("emotionName = 'happy'")
            note.emotion = happys.first
            note.hasPerson = true
            note.personName = "문규"
            note.hasActivity = true
            note.activityName = "코딩"
            note.memo = "오늘은 커피빈에서 하루종일 코딩."
            
            try! self.realm!.write {
                self.realm!.add(note)
            }
        }
    }
}

