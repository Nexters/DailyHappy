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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickMoodLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
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
    
    @IBOutlet weak var emotionNameText: UILabel!
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    let emotionMaker = EmotionMaker()
    var note = Note()
    
    var currentKeyword = Constants.Keyword.activity
    var isShowKeyboard = false
    var isFocusKeywordTexField = false
    
    let selectedText = "_selected"
    var selectedIndex = 0
    
    var updateNoteId = 0
    
    var onDataAvailable : ((_ year:String, _ month:String)->())?
    weak var previousViewController: MainViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardWillShowNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelTexts()
        
        if updateNoteId > 0 {
            if let updateNote = realm.object(ofType: Note.self, forPrimaryKey: updateNoteId as AnyObject) {
                note.copy(updateNote)
                bindNoteData(note)
            }
        } else {
            note.emotion = "happy"
            selectedIndex = 0
            doneButton.backgroundColor = emotionMaker.getEmotionColor("happy")
            emotionNameText.text = emotionMaker.getDetailMent(emotionMaker.getEmotionType("happy"))
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Person)
            memoTextView.text = NSLocalizedString("memo_hint", comment: "hint text of memoTextView")
            personButton.alpha = 1.0
            currentKeyword = Constants.Keyword.person
            setDateButtonTitle(note.date as Date)
        }
        
        subscribeKeywordTextField()
        subscribeMemoTextView()
        setScrollViewKeyboardDismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardWillShowNotifications()
        unsubscribeToKeyboardWillHideNotification()
    }
    
    @IBAction func clickActivity(_ sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        activityButton.alpha = 1.0
        currentKeyword = Constants.Keyword.activity
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Activity)
        keywordTextField.text = self.note.activityName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickItem(_ sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        itemButton.alpha = 1.0
        currentKeyword = Constants.Keyword.item
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Item)
        keywordTextField.text = self.note.itemName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickAnniversary(_ sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        anniversaryButton.alpha = 1.0
        currentKeyword = Constants.Keyword.anniversary
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Anniversary)
        keywordTextField.text = self.note.anniversaryName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickPerson(_ sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        personButton.alpha = 1.0
        currentKeyword = Constants.Keyword.person
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Person)
        keywordTextField.text = self.note.personName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickPlace(_ sender: UIButton) {
        setPreviouslyFocusedKeywordState()
        placeButton.alpha = 1.0
        currentKeyword = Constants.Keyword.place
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Place)
        keywordTextField.text = self.note.placeName
        keywordTextField.resignFirstResponder()
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNote(_ sender:UIButton) {
        print(self.note)
        
        setPreviouslyFocusedKeywordState()
        
        if updateNoteId == 0 {
            note.createdAt = Date()
            note.updatedAt = Date()
            note.id = Note.incrementeID()
        }
        
        try! self.realm.write { () -> Void in
            realm.add(note, update: true) // id가 에이터베이스에 없으면 create
            sendData(note.date)
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datePickerSegue" {
            definesPresentationContext = true
            let controller = segue.destination as! DatePickerViewController
            controller.view.backgroundColor = UIColor.clear
            controller.modalPresentationStyle = .overCurrentContext
            controller.date = self.note.date
            controller.previousViewController = self
        }
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func setLabelTexts() {
        titleLabel.text = NSLocalizedString("write_title", comment: "A title of write page")
        pickMoodLabel.text = NSLocalizedString("pick_mood", comment: "A label of collection view for emotions")
        keywordLabel.text = NSLocalizedString("keyword_label", comment: "A label of keyword Stack view")
        memoLabel.text = NSLocalizedString("memo_label", comment: "A label of memoTextView")
    }
  
    func sendData(_ date: Date) {
        if let main = previousViewController {
            main.isCreatedNote = true
        }
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.year], from: date)
        
        self.onDataAvailable?(String(describing: dateComponents.year), String(describing: dateComponents.month))
    }
    
    func setScrollViewKeyboardDismiss() {
        scrollView.keyboardDismissMode = .onDrag
    }
    
    func setPreviouslyFocusedKeywordState() {
        switch self.currentKeyword {
        case Constants.Keyword.activity:
            if self.note.activityName.isEmpty {
                activityButton.alpha = CGFloat(0.5)
                note.hasActivity = false
            } else {
                activityButton.alpha = CGFloat(1.0)
                note.hasActivity = true
            }
        case Constants.Keyword.item:
            if self.note.itemName.isEmpty {
                itemButton.alpha = CGFloat(0.5)
                note.hasItem = false
            } else {
                itemButton.alpha = CGFloat(1.0)
                note.hasItem = true
            }
        case Constants.Keyword.anniversary:
            if self.note.anniversaryName.isEmpty {
                anniversaryButton.alpha = CGFloat(0.5)
                note.hasAnniversary = false
            } else {
                anniversaryButton.alpha = CGFloat(1.0)
                note.hasAnniversary = true
            }
        case Constants.Keyword.person:
            if self.note.personName.isEmpty {
                personButton.alpha = CGFloat(0.5)
                note.hasPerson = false
            } else {
                personButton.alpha = CGFloat(1.0)
                note.hasPerson = true
            }
        case Constants.Keyword.place:
            if self.note.placeName.isEmpty {
                placeButton.alpha = CGFloat(0.5)
                note.hasPlace = false
            } else {
                placeButton.alpha = CGFloat(1.0)
                note.hasPlace = true
            }
        }
    }
    
    func subscribeKeywordTextField() {
        keywordTextField.rx.text
            .subscribe(onNext: { keyword in
                switch self.currentKeyword {
                case .activity:
                    self.note.activityName = keyword!
                case .item:
                    self.note.itemName = keyword!
                case .anniversary:
                    self.note.anniversaryName = keyword!
                case .person:
                    self.note.personName = keyword!
                case .place:
                    self.note.placeName = keyword!
                }
        })
        .addDisposableTo(disposeBag)
    }
    
    func subscribeMemoTextView() {
        memoTextView.rx.text
            .subscribe(onNext: { memo in
                if memo == Constants.Placeholder.MemoPlaceholder {
                    return
                }
                
                self.note.memo = memo!
                }, onError: {error in
                    
                })
        .addDisposableTo(disposeBag)
    }
    
    func subscribeToKeyboardWillShowNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(WriteNoteViewController.keyboardWillShow(_:))    , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShowNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
       NotificationCenter.default.addObserver(self, selector: #selector(WriteNoteViewController.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardWillHideNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if isShowKeyboard {
            return
        }
        
        isShowKeyboard = true
        
        let userInfo = notification.userInfo
        let keyboardInfoFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let windowFrame = view.window!.convert(view.frame, from: view)
        let keyboardFrame = windowFrame.intersection(keyboardInfoFrame)
        let coveredFrame = view.window!.convert(keyboardFrame, to: view)
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, coveredFrame.size.height, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        let keywordTextFieldFrame = keywordTextField.superview?.frame
        if isFocusKeywordTexField {
            scrollView.scrollRectToVisible(keywordTextFieldFrame!, animated: false)
        } else {
            scrollView.scrollRectToVisible(CGRect(x: scrollView.contentSize.width - 1, y: scrollView.contentSize.height - 1, width: 1, height: 1), animated: true)
        }


        subscribeToKeyboardWillHideNotifications()
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if !isShowKeyboard {
            return
        }
        isShowKeyboard = false
        let contentInsets = UIEdgeInsets.zero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
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
    
    func setKeywordTextFieldPlaceholder(_ placeholer: String) {
        keywordTextField.attributedPlaceholder = NSAttributedString(string: placeholer, attributes: [NSForegroundColorAttributeName: Constants.Color.lightGray])
    }
    
    func setDateButtonTitle(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateButton.setTitle(dateFormatter.string(from: date), for: UIControlState())
    }
    
    func bindNoteData(_ note: Note) {
        setDateButtonTitle(note.date as Date)
        
        let selectedIndex = IndexPath(item: emotionMaker.getEmotionIndex(note.emotion), section: 0)
        emotionCollectionView.delegate?.collectionView!(emotionCollectionView, didSelectItemAt: selectedIndex)
        emotionCollectionView.scrollToItem(at: selectedIndex, at: UICollectionViewScrollPosition.left, animated: true)
        
        activityButton.alpha = note.hasActivity ? 1.0 : 0.5
        itemButton.alpha = note.hasItem ? 1.0 : 0.5
        anniversaryButton.alpha = note.hasAnniversary ? 1.0 : 0.5
        personButton.alpha = note.hasPerson ? 1.0 : 0.5
        placeButton.alpha = note.hasPlace ? 1.0 : 0.5
        
        if note.hasActivity {
            currentKeyword = Constants.Keyword.activity
            keywordTextField.text = note.activityName
        } else if note.hasItem {
            currentKeyword = Constants.Keyword.item
            keywordTextField.text = note.itemName
        } else if note.hasAnniversary {
            currentKeyword = Constants.Keyword.anniversary
            keywordTextField.text = note.anniversaryName
        } else if note.hasPerson {
            currentKeyword = Constants.Keyword.person
            keywordTextField.text = note.personName
        } else if note.hasPlace {
            currentKeyword = Constants.Keyword.place
            keywordTextField.text = note.placeName
        }
        
        memoTextView.text = note.memo
    }
}

extension WriteNoteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionMaker.getEmotionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emotionCell", for: indexPath) as! EmotionImageCell
        let imageName = emotionMaker.getIcImagename(indexPath.row)
        cell.bind(selectedIndex == indexPath.row, imageName: imageName)
        
        return cell
    }
}

extension WriteNoteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            return
        }
        
        let previousSelectedIndex = IndexPath(item: selectedIndex, section: 0)
        selectedIndex = indexPath.row
        
        collectionView.reloadItems(at: [previousSelectedIndex])
        collectionView.reloadItems(at: [indexPath])
        
        note.emotion = emotionMaker.getEmotionName(selectedIndex)
        doneButton.backgroundColor = emotionMaker.getEmotionColor(selectedIndex)
        emotionNameText.text = emotionMaker.getDetailMent(selectedIndex)
    }
}

extension WriteNoteViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setPreviouslyFocusedKeywordState()
        isFocusKeywordTexField = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isFocusKeywordTexField = true
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isFocusKeywordTexField = false
        switch currentKeyword {
        case .activity:
        setKeywordTextFieldPlaceholder(Constants.Placeholder.Activity)
        case .item:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Item)
        case .anniversary:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Anniversary)
        case .person:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Person)
        case .place:
            setKeywordTextFieldPlaceholder(Constants.Placeholder.Place)
 
        }
    }
}

extension WriteNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.Placeholder.MemoPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.white
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Placeholder.MemoPlaceholder
            textView.textColor = Constants.Color.lightGray
        }
        textView.resignFirstResponder()
    }
}


