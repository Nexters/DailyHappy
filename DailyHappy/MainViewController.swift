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
    private var allNoteResults:[Note]=[]
    private var year = 1100
    private var month = 1
    var isCreatedNote = false
    @IBOutlet weak var selectMonthButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setSelectMonthButtonText()
        updateDataFromRealm()
        tableView.reloadData()
        if isCreatedNote {
            tableViewScrollToBottom(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        print(realm!.path)
        
        if( year == 1100) {
            setCurrentDate()
        }
        initBackground()
        initButtons()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let SelectVC = segue.destinationViewController as? SelectMonthViewController {
            SelectVC.setSelectYear(year)
            SelectVC.setAllNotes(allNoteResults)
            SelectVC.onDataAvailable = {[weak self](year, month) in
                if let weakSelf = self {
                    weakSelf.setYearUsingString(year)
                    weakSelf.setMonthUsingString(month)
                    weakSelf.setSelectMonthButtonText()
                }
            }
        } else if let writeNote = segue.destinationViewController as? WriteNoteViewController {
            writeNote.previousViewController = self
            writeNote.onDataAvailable = {[weak self](year, month) in
                if let weakSelf = self {
                    weakSelf.setYearUsingString(year)
                    weakSelf.setMonthUsingString(month)
                    weakSelf.setSelectMonthButtonText()
                }
            }
        }
    }

    func setYear(year:Int) {
        self.year = year
    }
    func setMonth(month:Int) {
        self.month = month
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
    
    private func updateDataFromRealm() {
        setNoteResultsFromRealm()
        setAllNoteResultsFromRealm()
    }
    
    private func setNoteResultsFromRealm() {
        let startDate = String(year) + "-" + String(month)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M"
        let startNSDate = dateFormatter.dateFromString(startDate)!
        
        let components: NSDateComponents = NSDateComponents()
        components.setValue(1, forComponent: NSCalendarUnit.Month);
        let endNSDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startNSDate, options: NSCalendarOptions(rawValue: 0))
        
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startNSDate, endNSDate!)
        let results = realm!.objects(Note).filter(predicate).sorted("date", ascending: true)
        noteResults.removeAll()
        for result in results {
            noteResults.append(result)
        }
    }
    
    private func setAllNoteResultsFromRealm() {
        let results = realm!.objects(Note)
        allNoteResults.removeAll()
        for result in results {
            allNoteResults.append(result)
        }

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

    func OnShowDetailView(id:Int) {
        let DetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
        /*
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromRight
        self.view.window!.layer.addAnimation( transition, forKey: nil)
        */
        DetailVC.setNoteId(id)
        self.presentViewController(DetailVC, animated: false, completion: nil)
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        setTableviewStyle(tableView)
        setEmptyMemolabel()
        return noteResults.count
    }
    
    func setTableviewStyle(tableView:UITableView) {
        tableView.allowsSelection = true
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    func setEmptyMemolabel() {
        if(noteResults.count < 1) {
            emptyMemoLabel.text = "무엇이 당신을 행복하게\n만드는 지 찾아보세요!"
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
        cell.setNoteMemoImage(note.memo)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        cell.onButtonSelected = {
            self.OnShowDetailView(note.id)
        }
        
        return cell
    }
}

