//
//  MainTableViewCell.swift
//  DailyHappy
//
//  Created by seokjoong on 2015. 12. 30..
//  Copyright © 2015년 TeamNexters. All rights reserved.
//

import UIKit

struct Cardtag {
    enum Tagtype{
        case Person
        case Place
        case Item
        case Activity
        case Anniversary
        
        init() {
            self = .Person
        }
    }
    var itemtype : Tagtype
    var content : String
    var index : Int
    
    func getIconimageName () ->(String) {
        var result = ""
        switch itemtype {
        case .Person:
            result = "CarditemPersonImage"
        case .Place:
            result = "CarditemPlaceImage"
        case .Item:
            result = "CarditemItemImage"
        case .Activity:
            result = "CarditemActivityImage"
        case .Anniversary:
            result = "CarditemAnniversaryImage"
        }
        return result
    }
    
    init(itemType: Tagtype, itemText: String, itemIndex: Int) {
        self.itemtype = itemType
        self.content = itemText
        self.index =  itemIndex
    }

}


class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var firstitemLabel: UILabel!
    @IBOutlet weak var seconditemLabel: UILabel!
    @IBOutlet weak var thirditemLabel: UILabel!
    @IBOutlet weak var fourthitemLabel: UILabel!
    @IBOutlet weak var fifthitemLabel: UILabel!
    
    @IBOutlet weak var firstitemIcon: UIImageView!
    @IBOutlet weak var seconditemIcon: UIImageView!
    @IBOutlet weak var thirditemIcon: UIImageView!
    @IBOutlet weak var fourthitemIcon: UIImageView!
    @IBOutlet weak var fifthitemIcon: UIImageView!

    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var emoticonImage: UIImageView!

    private var itemLabels:[UILabel]=[]
    private var itemIcons:[UIImageView]=[]
    
    @IBOutlet weak var ItemView: MainItemView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inititemLabels()
        inititemIcons()
    }
    func inititemLabels() {
        itemLabels.append(firstitemLabel)
        itemLabels.append(seconditemLabel)
        itemLabels.append(thirditemLabel)
        itemLabels.append(fourthitemLabel)
        itemLabels.append(fifthitemLabel)
    }

    func inititemIcons() {
        itemIcons.append(firstitemIcon)
        itemIcons.append(seconditemIcon)
        itemIcons.append(thirditemIcon)
        itemIcons.append(fourthitemIcon)
        itemIcons.append(fifthitemIcon)
    }
   
 

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func addCarditem(tag: Cardtag){
        if (tag.index < itemLabels.count) {
            itemLabels[tag.index].text = tag.content
        }
        if (tag.index < itemIcons.count) {
            itemIcons[tag.index].image = UIImage(named: tag.getIconimageName())
        }
    }
    func clearCarditem(index: Int) {
        if (index < itemLabels.count) {
            itemLabels[index].text = ""
        }
        if (index < itemIcons.count) {
            itemIcons[index].image = UIImage()
        }
    }
    
    func setDatetimeText(date: NSDate ) {
        datetimeLabel.text = getCardDateFormat(date)
    }
    func setemoticonImage(imgName: String ) {
        emoticonImage.image = UIImage(named: imgName)
    }
    
    func setCellStyle(color:UIColor) {
        backgroundColor = UIColor.clearColor()
        ItemView.setBackgorundColor(color)
    }
    func getCardDateFormat(date:NSDate) ->(String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd EEE"
        let createDate = dateFormatter.stringFromDate(date)
        return createDate
    }

    func setCellItems(note:Note) {
        
        var cardItemindex = 0
        if(note.hasPerson) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.Person, itemText: note.personName, itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasItem) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.Item, itemText: note.itemName, itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasActivity) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.Activity, itemText: note.activityName, itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasAnniversary) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.Anniversary, itemText: note.anniversaryName, itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasPlace) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.Place, itemText: note.placeName, itemIndex: cardItemindex))
            cardItemindex++
        }
        
        
        while cardItemindex < 5 {
            clearCarditem(cardItemindex)
            cardItemindex++
        }

        
    }
   
}
