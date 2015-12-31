//
//  MainItemView.swift
//  DailyHappy
//
//  Created by seokjoong on 2015. 12. 30..
//  Copyright © 2015년 TeamNexters. All rights reserved.
//

import UIKit

class MainItemView: UIView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()
        //fatalError("This class does not support NSCoding")
    }
    
    func addBehavior (){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        
    }
    
    func setBackgorundColor(backcolor: UIColor) {
        self.backgroundColor = backcolor
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
