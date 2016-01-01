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
    
    @IBOutlet var WriteButton: MKButton!
    @IBOutlet weak var emptyMemoLabel: UILabel!
    @IBOutlet weak var tableView: MainTableView!
    
    var realm:Realm?
    let emotionMaker:EmotionMaker = EmotionMaker()
    private var noteResults:[Note]=[]
    private var year = 2016
    private var month = 1
    @IBOutlet weak var selectMonthButton: UIButton!
    
    func setYear(year:Int) {
        self.year = year
    }
    func setMonth(month:Int) {
        self.month = month
    }

    override func viewWillAppear(animated: Bool) {
        setNoteResultsFromRealm()
        tableView.reloadData()
    }
    @IBAction func showSelectMonth(sender: AnyObject) {
        let SelectMonthVC = self.storyboard?.instantiateViewControllerWithIdentifier("SelectMonthVC") as! SelectMonthViewController
        
        self.presentViewController(SelectMonthVC, animated: false, completion: nil)
    }
    
    private func setNoteResultsFromRealm() {
        let startDate = String(year) + "-" + String(month)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let startNSDate = dateFormatter.dateFromString(startDate)!
        
        let components: NSDateComponents = NSDateComponents()
        components.setValue(1, forComponent: NSCalendarUnit.Month);
        let endNSDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startNSDate, options: NSCalendarOptions(rawValue: 0))
        
        
        let predicate = NSPredicate(format: "createdAt >= %@ AND createdAt < %@", startNSDate, endNSDate!)
        let results = realm!.objects(Note).filter(predicate)
        noteResults.removeAll()
        for result in results {
            noteResults.append(result)
        }
        print(noteResults)
    }
    
    @IBAction func ShowWriteView(sender: AnyObject) {
        let WriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("WriteVC") as! WriteNoteViewController
        
        self.presentViewController(WriteVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        createEmotionTable()
            .subscribeNext { (Bool) -> Void in
                //let emotions = self.realm.objects(Emotion)
                //print(emotions)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        initBackground()
        initWriteButton()
    }
    
    func initBackground() {
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
    }
    
    func initWriteButton() {
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
            
            let angry = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Angry)
            let joy = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Joy)
            let awesome = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Awesome)
            let flutter = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Flutter)
            let happy = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Happy)
            let loved = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Loved)
            let sad = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Sad)
            let relaxed = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Relaxed)
            let confused = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Confused)
            let worried = self.emotionMaker.getEmotioninstance(EmotionMaker.Emotiontype.Worried)
            
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


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        setTableviewStyle(tableView)
        setEmptyMemolabel()
        return noteResults.count
    }
    
    func setTableviewStyle(tableView:UITableView) {
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func setEmptyMemolabel() {
        if(noteResults.count < 1) {
            emptyMemoLabel.text = "글이 없습니다.\n작성해 주세요."
            emptyMemoLabel.hidden = false
        } else {
            emptyMemoLabel.hidden = true
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell") as! MainTableViewCell
        if(noteResults.count <= indexPath.row) {
            return cell
        }
        let note = noteResults[indexPath.row]
        let emotionType = self.emotionMaker.getEmotionType((note.emotion?.emotionName)!)
        
        cell.setCellStyle(self.emotionMaker.getEmotionColor(emotionType))
        cell.setDatetimeText(note.date)
        cell.setemoticonImage(self.emotionMaker.getCardicImagename(emotionType))
        cell.setCellItems(note)
      
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}

