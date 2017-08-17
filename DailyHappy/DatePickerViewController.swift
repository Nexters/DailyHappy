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
   
    var date:Date?
    weak var previousViewController: WriteNoteViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.setValue(0.8, forKey: "alpha")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.date = self.date! 
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func goBack(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectDate(_ sender:UIButton) {
        let selectedDate = datePicker.date
        previousViewController!.note.date = selectedDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        previousViewController?.dateButton.setTitle(dateFormatter.string(from: selectedDate), for: UIControlState())
        
        dismiss(animated: true, completion: nil)
    }
}
