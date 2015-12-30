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
    
    let realm = try! Realm()
    var emotions: Results<Emotion>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotions = self.realm.objects(Emotion)
    }
}

extension WriteNoteViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emotions!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionCell", forIndexPath: indexPath) as! EmotionImageCell
        let emotion = self.emotions![indexPath.row]
        
        cell.imageView?.image = UIImage(named: (emotion.emotionName))
        
        return cell
    }
}