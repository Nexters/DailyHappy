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

class WriteNoteViewController: UIViewController{
    @IBOutlet weak var emotionCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    let realm = try! Realm()
    var emotions: Results<Emotion>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotions = self.realm.objects(Emotion)
        
        let emotion = emotions?.first
        doneButton.backgroundColor = getEmotionColor(emotion!)
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