//
//  DatePickerViewController.swift
//  DailyHappy
//
//  Created by MunkyuShin on 1/1/16.
//  Copyright © 2016 TeamNexters. All rights reserved.
//

import Foundation
import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
   
    var date:NSDate?
    weak var previousViewController: WriteNoteViewController?
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.locale = NSLocale(localeIdentifier: "ko_KR")
        datePicker.setValue(0.8, forKey: "alpha")
    }
    
    override func viewWillAppear(animated: Bool) {
        datePicker.date = self.date! 
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func goBack(sender:UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectDate(sender:UIButton) {
        let selectedDate = datePicker.date
        previousViewController!.note.date = selectedDate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR")
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        previousViewController?.dateButton.setTitle(dateFormatter.stringFromDate(selectedDate), forState: .Normal)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}