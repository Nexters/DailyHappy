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
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var anniversaryButton: UIButton!
   
    @IBOutlet weak var personButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    var emotions: Results<Emotion>?
    let note = Note()
    var currentKeyword = Constants.Keyword.Activity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotions = self.realm.objects(Emotion)
        
        let emotion = emotions?.first
        doneButton.backgroundColor = getEmotionColor(emotion!)
        
        keywordTextField.attributedPlaceholder = NSAttributedString(string:keywordTextField.placeholder!,attributes: [NSForegroundColorAttributeName: Constants.Color.lightGray])
        
        memoTextField.attributedPlaceholder = NSAttributedString(string:memoTextField.placeholder!,attributes: [NSForegroundColorAttributeName: Constants.Color.lightGray])
        
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
    
    @IBAction func clickActivity(sender: UIButton) {
        note.hasActivity = true
        currentKeyword = Constants.Keyword.Activity
        keywordTextField.text = self.note.activityName
        setKeywordButtonsAlpha()
    }
    
    @IBAction func clickItem(sender: UIButton) {
        note.hasItem = true
        currentKeyword = Constants.Keyword.Item
        keywordTextField.text = self.note.itemName
        setKeywordButtonsAlpha()
    }
    
    @IBAction func clickAnniversary(sender: UIButton) {
        note.hasAnniversary = true
        currentKeyword = Constants.Keyword.Anniversary
        keywordTextField.text = self.note.anniversaryName
        setKeywordButtonsAlpha()
    }
    
    @IBAction func clickPerson(sender: UIButton) {
        note.hasPerson = true
        currentKeyword = Constants.Keyword.Person
        keywordTextField.text = self.note.personName
        setKeywordButtonsAlpha()
    }
    
    @IBAction func clickPlace(sender: UIButton) {
        note.hasPlace = true
        currentKeyword = Constants.Keyword.Place
        keywordTextField.text = self.note.placeName
        setKeywordButtonsAlpha()
    }
    
    
    func setKeywordButtonsAlpha() {
        initializeKeywordButtonsAlpha()
        
        switch self.currentKeyword {
        case Constants.Keyword.Activity:
            activityButton.alpha = CGFloat(1.0)
        case Constants.Keyword.Item:
            itemButton.alpha = CGFloat(1.0)
        case Constants.Keyword.Anniversary:
            anniversaryButton.alpha = CGFloat(1.0)
        case Constants.Keyword.Person:
            personButton.alpha = CGFloat(1.0)
        case Constants.Keyword.Place:
            placeButton.alpha = CGFloat(1.0)
        }
    }
    
    func initializeKeywordButtonsAlpha() {
        activityButton.alpha = CGFloat(0.5)
        itemButton.alpha = CGFloat(0.5)
        anniversaryButton.alpha = CGFloat(0.5)
        personButton.alpha = CGFloat(0.5)
        placeButton.alpha = CGFloat(0.5)
    }
    
}

extension WriteNoteViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emotions!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionCell", forIndexPath: indexPath) as! EmotionImageCell
        let emotion = self.emotions![indexPath.row]
        
        cell.emotion = emotion
        cell.imageView?.image = UIImage(named: (emotion.emotionName))
        return cell
    }
}

extension WriteNoteViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let emotion = self.emotions![indexPath.row]
        note.emotion = emotion
        doneButton.backgroundColor = getEmotionColor(emotion)
    }
}


func getEmotionColor(emotion: Emotion) -> UIColor {
    let red = CGFloat(emotion.emotionColorRed)
    let green = CGFloat(emotion.emotionColorGreen)
    let blue = CGFloat(emotion.emotionColorBlue)
    
    let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    
    return color
}