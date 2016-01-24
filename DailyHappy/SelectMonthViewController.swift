//
//  SelectMonthViewController.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 1..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import UIKit

class SelectMonthViewController: UIViewController {

    @IBOutlet weak var selectMonthStackView: SelectMonthStackView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    
    @IBOutlet var JanButton: MKButton!
    @IBOutlet var AprButton: MKButton!
    @IBOutlet var JulButton: MKButton!
    @IBOutlet var OctButton: MKButton!

    @IBOutlet var FebButton: MKButton!
    @IBOutlet var MayButton: MKButton!
    @IBOutlet var AugButton: MKButton!
    @IBOutlet var NovButton: MKButton!

    @IBOutlet var MarButton: MKButton!
    @IBOutlet var JunButton: MKButton!
    @IBOutlet var SepButton: MKButton!
    @IBOutlet var DecButton: MKButton!
    
    
    @IBOutlet weak var JanLabel: UILabel!
    @IBOutlet weak var AprLabel: UILabel!
    @IBOutlet weak var JulLabel: UILabel!
    @IBOutlet weak var OctLabel: UILabel!
    
    @IBOutlet weak var FebLabel: UILabel!
    @IBOutlet weak var MayLabel: UILabel!
    @IBOutlet weak var AugLabel: UILabel!
    @IBOutlet weak var NovLabel: UILabel!
    
    @IBOutlet weak var MarLabel: UILabel!
    @IBOutlet weak var JubLabel: UILabel!
    @IBOutlet weak var SepLabel: UILabel!
    @IBOutlet weak var DecLabel: UILabel!
    
    private var selectYear = 2015
    private var selectMonth = 1
    
    let emotionMaker:EmotionMaker = EmotionMaker()
    private var monthButtons:[MKButton]=[]
    private var monthLabels:[UILabel]=[]
    private var allNoteResults:[Note]=[]
    private var numPostOfMonth: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    private var numEmotionOfMonth = [[Int]](count: 12, repeatedValue:[Int](count:10, repeatedValue:0))
    
    @IBOutlet weak var yearLabel: UILabel!
    
    var onDataAvailable : ((year:String, month:String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        // Do any additional setup after loading the view.
        selectMonthStackView.backgroundColor = UIColor.clearColor()
        leftView.backgroundColor = UIColor.clearColor()
        centerView.backgroundColor = UIColor.clearColor()
        rightView.backgroundColor = UIColor.clearColor()
        yearLabel.text  = String(selectYear)
        
        setPostCount()
        
        initMonthLabels()
        initMonthButtons()
        setMonthButtons()
        setMonthLabels()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func sendData(year:String, month:String) {
        self.onDataAvailable?(year: year, month: month)
    }
    
    func setSelectYear(year:Int) {
        self.selectYear = year
    }
    func setSelectMonth(month:Int) {
        self.selectMonth = month
    }
    
    func setAllNotes(dataArray:[Note]) {
        allNoteResults.removeAll()
        for data in dataArray {
            allNoteResults.append(data)
        }
    }

    func initMonthLabels() {
        monthLabels.append(JanLabel)
        monthLabels.append(FebLabel)
        monthLabels.append(MarLabel)
        monthLabels.append(AprLabel)
        monthLabels.append(MayLabel)
        monthLabels.append(JubLabel)
        monthLabels.append(JulLabel)
        monthLabels.append(AugLabel)
        monthLabels.append(SepLabel)
        monthLabels.append(OctLabel)
        monthLabels.append(NovLabel)
        monthLabels.append(DecLabel)
    }
    
    func initMonthButtons() {
        monthButtons.append(JanButton)
        monthButtons.append(FebButton)
        monthButtons.append(MarButton)
        monthButtons.append(AprButton)
        monthButtons.append(MayButton)
        monthButtons.append(JunButton)
        monthButtons.append(JulButton)
        monthButtons.append(AugButton)
        monthButtons.append(SepButton)
        monthButtons.append(OctButton)
        monthButtons.append(NovButton)
        monthButtons.append(DecButton)
    }

    func setMonthButtons() {
        var count = 0
        for mkbutton in monthButtons {
            
            var max = 0
            var maxIndex = 0
            for i in 0...9 {
                if max <= numEmotionOfMonth[count][i] {
                    max = numEmotionOfMonth[count][i]
                    maxIndex = i
                }
            }
            if max == 0 {
                 mkbutton.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.2)
            } else {
                let color = emotionMaker.getEmotionColor(EmotionMaker.Emotiontype(rawValue: maxIndex)!).colorWithAlphaComponent(0.2)
                mkbutton.backgroundColor = color
            }
            count++
        }
    }
    
    func setMonthLabels() {
        var count = 0
        for label in monthLabels {
            let numberOfPosts = numPostOfMonth[count]
            if numberOfPosts <= 1 {
                label.text = String.localizedStringWithFormat(NSLocalizedString("%d_card", comment: "number of card"), numberOfPosts)
            } else {
                label.text = String.localizedStringWithFormat(NSLocalizedString("%d_cards", comment: "number of card"), numberOfPosts)
            }
            count++
        }
    }
    
    func setPostCount() {
        for i in 0...11 {
            numPostOfMonth[i] = 0
            for j in 0...9 {
                numEmotionOfMonth[i][j] = 0
            }
        }
        
        for note in allNoteResults {
           let comp = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: note.date)
           if(selectYear == Int(comp.year)) {
                numPostOfMonth[comp.month-1]++
                numEmotionOfMonth[comp.month-1][emotionMaker.getEmotionType(note.emotion).rawValue]++
            }
        }
    }

    func initBackground() {
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
    }
   
    @IBAction func OnJanButton(sender: AnyObject) {        
        setSelectMonth(1)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func OnAprButton(sender: AnyObject) {
        setSelectMonth(4)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnJulButton(sender: AnyObject) {
        setSelectMonth(7)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnOctButton(sender: AnyObject) {
        setSelectMonth(10)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func OnFebButton(sender: AnyObject) {
        setSelectMonth(2)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnMayButton(sender: AnyObject) {
        setSelectMonth(5)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnAugButton(sender: AnyObject) {
        setSelectMonth(8)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnNovButton(sender: AnyObject) {
        setSelectMonth(11)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func OnMarButton(sender: AnyObject) {
        setSelectMonth(3)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnJubButton(sender: AnyObject) {
        setSelectMonth(6)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnSepButton(sender: AnyObject) {
        setSelectMonth(9)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func OnDecButton(sender: AnyObject) {
        setSelectMonth(12)
        sendData(String(selectYear), month: String(selectMonth))
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func OnBackYearButton(sender: AnyObject) {
        setSelectYear(selectYear-1)
        yearLabel.text  = String(selectYear)
        setPostCount()
        setMonthLabels()
        setMonthButtons()
        
    }
    @IBAction func OnForwardYearButton(sender: AnyObject) {
        setSelectYear(selectYear+1)
        yearLabel.text  = String(selectYear)
        setPostCount()
        setMonthLabels()
        setMonthButtons()
    }
}
