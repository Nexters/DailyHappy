//
//  LaunchScreenViewController.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/29/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import RxCocoa
import RxSwift

class WriteNoteViewController: UIViewController{
    @IBOutlet weak var emotionCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var keywordTextField: UITextField!

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var anniversaryButton: UIButton!
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var personButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    let emotionMaker = EmotionMaker()
    let note = Note()
    var currentKeyword = Constants.Keyword.Activity
    var isShowKeyboard = false
    var isFocusKeywordTexField = false
    
    let selectedText = "_selected"
    var selectedIndex = 0
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardWillShowNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.backgroundColor = emotionMaker.getEmotionColor("angry")
        
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Activity)
        memoTextView.text = Constants.Placeholder.MemoPlaceholder
        setDateButtonTitle(note.date)
        
        activityButton.alpha = 1.0
        
        subscribeKeywordTextField()
        subscribeMemoTextView()
        setScrollViewKeyboardDismiss()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardWillShowNotifications()
        unsubscribeToKeyboardWillHideNotification()
    }
    
    @IBAction func clickActivity(sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        activityButton.alpha = 1.0
        currentKeyword = Constants.Keyword.Activity
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Activity)
        keywordTextField.text = self.note.activityName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickItem(sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        itemButton.alpha = 1.0
        currentKeyword = Constants.Keyword.Item
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Item)
        keywordTextField.text = self.note.itemName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickAnniversary(sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        anniversaryButton.alpha = 1.0
        currentKeyword = Constants.Keyword.Anniversary
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Anniversary)
        keywordTextField.text = self.note.anniversaryName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickPerson(sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        personButton.alpha = 1.0
        currentKeyword = Constants.Keyword.Person
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Person)
        keywordTextField.text = self.note.personName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickPlace(sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        placeButton.alpha = 1.0
        currentKeyword = Constants.Keyword.Place
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Place)
        keywordTextField.text = self.note.placeName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickBackButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createNote(sender:UIButton) {
        print(self.note)
        
        setPreviouslyFocusedKeywordState()
        note.createdAt = NSDate()
        note.updatedAt = NSDate()
        note.id = Note.incrementeID()
        
        try! self.realm.write { () -> Void in
            realm.add(note)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "datePickerSegue" {
            definesPresentationContext = true
            let controller = segue.destinationViewController as! DatePickerViewController
            controller.view.backgroundColor = UIColor.clearColor()
            controller.modalPresentationStyle = .OverCurrentContext
            controller.date = self.note.date
            controller.previousViewController = self
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
    func setScrollViewKeyboardDismiss() {
        scrollView.keyboardDismissMode = .OnDrag
    }
    
    func setPreviouslyFocusedKeywordState() {
        switch self.currentKeyword {
        case Constants.Keyword.Activity:
            if self.note.activityName.isEmpty {
                activityButton.alpha = CGFloat(0.5)
            } else {
                activityButton.alpha = CGFloat(1.0)
                note.hasActivity = true
            }
        case Constants.Keyword.Item:
            if self.note.itemName.isEmpty {
                itemButton.alpha = CGFloat(0.5)
            } else {
                itemButton.alpha = CGFloat(1.0)
                note.hasItem = true
            }
        case Constants.Keyword.Anniversary:
            if self.note.anniversaryName.isEmpty {
                anniversaryButton.alpha = CGFloat(0.5)
            } else {
                anniversaryButton.alpha = CGFloat(1.0)
                note.hasAnniversary = true
            }
        case Constants.Keyword.Person:
            if self.note.personName.isEmpty {
                personButton.alpha = CGFloat(0.5)
            } else {
                personButton.alpha = CGFloat(1.0)
                note.hasPerson = true
            }
        case Constants.Keyword.Place:
            if self.note.placeName.isEmpty {
                placeButton.alpha = CGFloat(0.5)
            } else {
                placeButton.alpha = CGFloat(1.0)
                note.hasPlace = true
            }
        }
    }
    
    func subscribeKeywordTextField() {
        let subscription = keywordTextField.rx_text
            .subscribeNext{ keyword in
                switch self.currentKeyword {
                case .Activity:
                    self.note.activityName = keyword
                case .Item:
                    self.note.itemName = keyword
                case .Anniversary:
                    self.note.anniversaryName = keyword
                case .Person:
                    self.note.personName = keyword
                case .Place:
                    self.note.placeName = keyword
                }
        }
        disposeBag.addDisposable(subscription)
    }
    
    func subscribeMemoTextView() {
        let subscription = memoTextView.rx_text
        .subscribeNext { (memo) -> Void in
            if memo == Constants.Placeholder.MemoPlaceholder {
                return
            }
            
            self.note.memo = memo
        }
        disposeBag.addDisposable(subscription)
    }
    
    func subscribeToKeyboardWillShowNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardWillHideNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if isShowKeyboard {
            return
        }
        
        isShowKeyboard = true
        
        let userInfo = notification.userInfo
        let keyboardInfoFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let windowFrame = view.window!.convertRect(view.frame, fromView: view)
        let keyboardFrame = CGRectIntersection(windowFrame, keyboardInfoFrame)
        let coveredFrame = view.window!.convertRect(keyboardFrame, toView: view)
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, coveredFrame.size.height, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height)
        
        let keywordTextFieldFrame = keywordTextField.superview?.frame
        if isFocusKeywordTexField {
            scrollView.scrollRectToVisible(keywordTextFieldFrame!, animated: false)
        } else {
            scrollView.scrollRectToVisible(CGRect(x: scrollView.contentSize.width - 1, y: scrollView.contentSize.height - 1, width: 1, height: 1), animated: true)
        }


        subscribeToKeyboardWillHideNotifications()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if !isShowKeyboard {
            return
        }
        isShowKeyboard = false
        let contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height)
        if isFocusKeywordTexField {
            scrollView.scrollRectToVisible(CGRect(x: scrollView.contentSize.width - 1, y: 0, width: 1, height: 1), animated: false)
        }

        
        subscribeToKeyboardWillShowNotifications()
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setKeywordTextFieldPlaceholder(placeholer: String) {
        keywordTextField.attributedPlaceholder = NSAttributedString(string: placeholer, attributes: [NSForegroundColorAttributeName: Constants.Color.lightGray])
    }
    
    func setDateButtonTitle(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR")
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateButton.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
    }
}

extension WriteNoteViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionMaker.getEmotionCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionCell", forIndexPath: indexPath) as! EmotionImageCell
        let imageName = emotionMaker.getIcImagename(indexPath.row)
        
        cell.bind(selectedIndex == indexPath.row, imageName: imageName)
        return cell
    }
}

extension WriteNoteViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        note.emotion = emotionMaker.getEmotionName(selectedIndex)
        doneButton.backgroundColor = emotionMaker.getEmotionColor(selectedIndex)
        
        collectionView.reloadData()
    }
}

extension WriteNoteViewController: UITextFieldDelegate {
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isFocusKeywordTexField = false
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        isFocusKeywordTexField = true
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        isFocusKeywordTexField = false
        switch currentKeyword {
        case .Activity:
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Activity)
        case .Item:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Item)
        case .Anniversary:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Anniversary)
        case .Person:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Person)
        case .Place:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Place)
 
        }
    }
}

extension WriteNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == Constants.Placeholder.MemoPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Placeholder.MemoPlaceholder
            textView.textColor = Constants.Color.lightGray
        }
        textView.resignFirstResponder()
    }
}


