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
    
    @IBOutlet weak var yearLabel: UILabel!
    
    var onDataAvailable : ((year:String, month:String)->())?
    func sendData(year:String, month:String) {
        self.onDataAvailable?(year: year, month: month)
    }
    
    func setSelectYear(year:Int) {
        self.selectYear = year
    }
    func setSelectMonth(month:Int) {
        self.selectMonth = month
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        // Do any additional setup after loading the view.
        selectMonthStackView.backgroundColor = UIColor.clearColor()
        leftView.backgroundColor = UIColor.clearColor()
        centerView.backgroundColor = UIColor.clearColor()
        rightView.backgroundColor = UIColor.clearColor()
        yearLabel.text  = String(selectYear)
        setMonthButtons()
        setMonthLabels()
        initMonthButtons()
        initMonthLabels()
    }
    func setMonthLabels() {
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
    
    func setMonthButtons() {
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

    
    
    func initMonthButtons() {
        for mkbutton in monthButtons {
            let color = emotionMaker.getEmotionColor(EmotionMaker.Emotiontype.Happy).colorWithAlphaComponent(0.2)
            mkbutton.backgroundColor = color
        }
    }
    
    func initMonthLabels() {
        var count = 0
        for label in monthLabels {
            count++
        label.text = String(count)+"개의 카드"
        }
    }

    
    
    func initBackground() {
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }
    @IBAction func OnForwardYearButton(sender: AnyObject) {
        setSelectYear(selectYear+1)
        yearLabel.text  = String(selectYear)
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
