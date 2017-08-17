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
    fileprivate var noteResults:[Note]=[]
    fileprivate var allNoteResults:[Note]=[]
    fileprivate var year = 1100
    fileprivate var month = 1
    var isCreatedNote = false
    @IBOutlet weak var selectMonthButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSelectMonthButtonText()
        updateDataFromRealm()
        tableView.reloadData()
        if isCreatedNote {
            isCreatedNote = false
            tableViewScrollToBottom(true)
        }
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SelectVC = segue.destination as? SelectMonthViewController {
            SelectVC.setSelectYear(year)
            SelectVC.setAllNotes(allNoteResults)
            SelectVC.onDataAvailable = {[weak self](year, month) in
                if let weakSelf = self {
                    weakSelf.setYearUsingString(year)
                    weakSelf.setMonthUsingString(month)
                    weakSelf.setSelectMonthButtonText()
                }
            }
        } else if let writeNote = segue.destination as? WriteNoteViewController {
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

    func setYear(_ year:Int) {
        self.year = year
    }
    func setMonth(_ month:Int) {
        self.month = month
    }

    
    func setSelectMonthButtonText() {
        selectMonthButton.setTitle(String(year) + ". " + String(month), for: UIControlState())
    }
    
    func setMonthUsingString(_ data: String) {
        setMonth(Int(data)!)
    }
    func setYearUsingString(_ data: String) {
        setYear(Int(data)!)
    }
    
    fileprivate func updateDataFromRealm() {
        setNoteResultsFromRealm()
        setAllNoteResultsFromRealm()
    }
    
    fileprivate func setNoteResultsFromRealm() {
        let startDate = String(year) + "-" + String(month)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M"
        let startNSDate = dateFormatter.date(from: startDate)!
        
        let components: DateComponents = DateComponents()
        (components as NSDateComponents).setValue(1, forComponent: NSCalendar.Unit.month);
        let endNSDate = (Calendar.current as NSCalendar).date(byAdding: components, to: startNSDate, options: NSCalendar.Options(rawValue: 0))
        
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startNSDate as CVarArg, endNSDate! as CVarArg)
        let results = realm!.objects(Note.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
        noteResults.removeAll()
        for result in results {
            noteResults.append(result)
        }
    }
    
    fileprivate func setAllNoteResultsFromRealm() {
        let results = realm!.objects(Note.self)
        allNoteResults.removeAll()
        for result in results {
            allNoteResults.append(result)
        }

    }
    
    func setCurrentDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let monthStr = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        let yearStr = dateFormatter.string(from: date)
        
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
        WriteButton.rippleLocation = .center
        
        WriteButton.layer.shadowOpacity = 0.75
        WriteButton.layer.shadowRadius = 3.5
        WriteButton.layer.shadowColor = UIColor.black.cgColor
        WriteButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
    }

    func OnShowDetailView(_ id:Int) {
        let DetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        /*
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromRight
        self.view.window!.layer.addAnimation( transition, forKey: nil)
        */
        DetailVC.setNoteId(id)
        self.present(DetailVC, animated: false, completion: nil)
    }
    
    func tableViewScrollToBottom(_ animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
            
        })
    }
}


extension MainViewController: UITableViewDelegate {
    
    
    func setTableviewStyle(_ tableView:UITableView) {
        tableView.allowsSelection = true
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    func setEmptyMemolabel() {
        if(noteResults.count < 1) {
            emptyMemoLabel.text = NSLocalizedString("timeline_empty_text", comment: "instruction for starter")
            emptyMemoLabel.isHidden = false
        } else {
            emptyMemoLabel.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension MainViewController: UITableViewDataSource { 
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        setTableviewStyle(tableView)
        setEmptyMemolabel()
        return noteResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as! MainTableViewCell
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        cell.onButtonSelected = {
            self.OnShowDetailView(note.id)
        }
        
        return cell
    }
 
}

