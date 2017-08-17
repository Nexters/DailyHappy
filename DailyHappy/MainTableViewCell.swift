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
        case person
        case place
        case item
        case activity
        case anniversary
        
        init() {
            self = .person
        }
    }
    var itemtype : Tagtype
    var content : String
    var index : Int
    
    func getIconimageName () ->(String) {
        var result = ""
        switch itemtype {
        case .person:
            result = "CarditemPersonImage"
        case .place:
            result = "CarditemPlaceImage"
        case .item:
            result = "CarditemItemImage"
        case .activity:
            result = "CarditemActivityImage"
        case .anniversary:
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
    @IBOutlet weak var cardMemoImage: UIImageView!

    fileprivate var itemLabels:[UILabel]=[]
    fileprivate var itemIcons:[UIImageView]=[]
    
    var onButtonSelected: (() -> Void)? = nil
    
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
   
 


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if(selected) {
            if let onButtonSelected = self.onButtonSelected {
                onButtonSelected()
            }
        }
    }
    
    
    
    func addCarditem(_ tag: Cardtag){
        if (tag.index < itemLabels.count) {
            itemLabels[tag.index].text = tag.content
        }
        if (tag.index < itemIcons.count) {
            itemIcons[tag.index].image = UIImage(named: tag.getIconimageName())
        }
    }
    func clearCarditem(_ index: Int) {
        if (index < itemLabels.count) {
            itemLabels[index].text = ""
        }
        if (index < itemIcons.count) {
            itemIcons[index].image = UIImage()
        }
    }
    
    func setDatetimeText(_ date: Date ) {
        datetimeLabel.text = getCardDateFormat(date)
    }
    func setemoticonImage(_ imgName: String ) {
        emoticonImage.image = UIImage(named: imgName)
    }
    
    func setCellStyle(_ color:UIColor) {
        backgroundColor = UIColor.clear
        ItemView.setBackgorundColor(color)
    }
    func getCardDateFormat(_ date:Date) ->(String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd EEEE"
        let createDate = dateFormatter.string(from: date)
        return createDate
    }

    
    func getItemString(_ data:String) ->(String){
        let endIndex = data.characters.count
        if(endIndex <= 5) {
            return data
        }
        return data.substring(with: (data.characters.index(data.startIndex, offsetBy: 0) ..< data.characters.index(data.endIndex, offsetBy: 5-endIndex))) + "..."

    }
    func setCellItems(_ note:Note) {
        
        var cardItemindex = 0
        if(note.hasPerson) {
            
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.person, itemText: getItemString(note.personName), itemIndex: cardItemindex))
            cardItemindex += 1
        }
        if(note.hasItem) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.item, itemText: getItemString(note.itemName), itemIndex: cardItemindex))
            cardItemindex += 1
        }
        if(note.hasActivity) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.activity, itemText: getItemString(note.activityName), itemIndex: cardItemindex))
            cardItemindex += 1
        }
        if(note.hasAnniversary) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.anniversary, itemText: getItemString(note.anniversaryName), itemIndex: cardItemindex))
            cardItemindex += 1
        }
        if(note.hasPlace) {
            addCarditem(Cardtag(itemType: Cardtag.Tagtype.place, itemText: getItemString(note.placeName), itemIndex: cardItemindex))
            cardItemindex += 1
        }
        
        
        while cardItemindex < 5 {
            clearCarditem(cardItemindex)
            cardItemindex += 1
        }

        
    }
    func setNoteMemoImage(_ data:String) {
        if(data != "") {
            cardMemoImage.isHidden = false
        } else {
            cardMemoImage.isHidden = true
        }
    }

   
}
