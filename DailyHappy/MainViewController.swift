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
    private var year = 1100
    private var month = 1
    @IBOutlet weak var selectMonthButton: UIButton!
    

    func setYear(year:Int) {
        self.year = year
    }
    func setMonth(month:Int) {
        self.month = month
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setSelectMonthButtonText()
        setNoteResultsFromRealm()
        tableView.reloadData()
    }
    func setSelectMonthButtonText() {
        selectMonthButton.setTitle(String(year) + ". " + String(month), forState: .Normal)
    }
    


    
    func setMonthUsingString(data: String) {
        setMonth(Int(data)!)
    }
    func setYearUsingString(data: String) {
        setYear(Int(data)!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let SelectVC = segue.destinationViewController as? SelectMonthViewController {
            SelectVC.setSelectYear(year)
            SelectVC.onDataAvailable = {[weak self](year, month) in
                if let weakSelf = self {
                    weakSelf.setYearUsingString(year)
                    weakSelf.setMonthUsingString(month)
                    weakSelf.setSelectMonthButtonText()
                }
            }
        }
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
        
        if( year == 1100) {
            setCurrentDate()
        }
        initBackground()
        initButtons()

    
    }
    
    func setCurrentDate() {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR")
        let monthStr = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "yyyy"
        let yearStr = dateFormatter.stringFromDate(date)
        
        setMonth(Int(monthStr)!)
        setYear(Int(yearStr)!)

    }
    
    func initBackground() {
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
    }
    
    func initButtons() {
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
        let emotionType = self.emotionMaker.getEmotionType((note.emotion))
        
        cell.setCellStyle(self.emotionMaker.getEmotionColor(emotionType))
        cell.setDatetimeText(note.date)
        cell.setemoticonImage(self.emotionMaker.getCardicImagename(emotionType))
        cell.setCellItems(note)
      
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}

