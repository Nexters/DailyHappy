//
//  EmotionImageCell.swift
//  DailyHappy
//
//  Created by MunkyuShin on 12/30/15.
//  Copyright © 2015 TeamNexters. All rights reserved.
//

import Foundation
import UIKit

class EmotionImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var emotion:Emotion?
    
    func bind(selected: Bool, imageName: String) {
        if selected {
            imageView?.image = UIImage(named: (imageName + "_selected"))
        } else {
            imageView?.image = UIImage(named: (imageName))
        }
    }
}