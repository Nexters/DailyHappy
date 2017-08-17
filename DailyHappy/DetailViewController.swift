//
//  DetailViewController.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 3..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import UIKit
import RealmSwift
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



struct Detailtag {
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
            result = "DetailPerson"
        case .place:
            result = "DetailPlace"
        case .item:
            result = "DetailItem"
        case .activity:
            result = "DetailActivity"
        case .anniversary:
            result = "DetailAnniversary"
        }
        return result
    }
    
    init(itemType: Tagtype, itemText: String, itemIndex: Int) {
        self.itemtype = itemType
        self.content = itemText
        self.index =  itemIndex
    }
    
}


class DetailViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollchildViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomStackViewHeight: NSLayoutConstraint!

    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var emoticonImage: UIImageView!
    @IBOutlet weak var emoticonMentLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    @IBOutlet weak var firstitemIcon: UIImageView!
    @IBOutlet weak var seconditemIcon: UIImageView!
    @IBOutlet weak var thirditemIcon: UIImageView!
    @IBOutlet weak var fourthitemIcon: UIImageView!
    @IBOutlet weak var fifthitemIcon: UIImageView!
    
    @IBOutlet weak var firstitemLabel: UILabel!
    @IBOutlet weak var seconditemLabel: UILabel!
    @IBOutlet weak var thirditemLabel: UILabel!
    @IBOutlet weak var fourthitemLabel: UILabel!
    @IBOutlet weak var fifthitemLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    fileprivate var itemLabels:[UILabel]=[]
    fileprivate var itemIcons:[UIImageView]=[]
    

    let realm = try! Realm()
    var id = 0
    var note: Note?
    let emotionMaker:EmotionMaker = EmotionMaker()
    let MaxMemoHeight = CGFloat(91)
    func setNoteId(_ id:Int) {
        self.id = id
    }
    
    func getNoteId() ->(Int) {
        return id
    }
    
    func initBackground() {
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
    }
    
    func initTopView() {
        topView.layer.masksToBounds = true
        topView.layer.cornerRadius = 3
    }
    func initBottomView() {
        bottomView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 3
    }

    func initMiddleView() {
        let border = CALayer()
        border.backgroundColor =  UIColor(colorLiteralRed: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: middleView.frame.size.height - 1,   width: UIScreen.main.bounds.size.width - (scrollView.frame.size.width - middleView.frame.size.width), height: 1)
        middleView.layer.addSublayer(border)
        middleView.layer.zPosition = 1
        middleView.backgroundColor =  UIColor(colorLiteralRed: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        initTopView()
        initBottomView()
        initMiddleView()
        inititemLabels()
        inititemIcons()
        
    }
    
    func updateAllViews() {
        note = realm.object(ofType: Note.self, forPrimaryKey: getNoteId() as AnyObject)
        
        setLabelTexts()
        setTopView()
        setMiddleView()
        setBottomView()
    }
    
    func setLabelTexts() {
        titleLabel.text = NSLocalizedString("detail_view_title", comment: "a title for DetailViewController")
        editButton.setTitle(NSLocalizedString("edit", comment: "title of edit button."), for: UIControlState())
        deleteButton.setTitle(NSLocalizedString("delete", comment: "title of delete button."), for: UIControlState())
    }
    
    func setTopView() {
        setDateLabel()
        setEmotionLayer()
    }
    
    func setMiddleView() {
         setDetailItems(note!)
    }
    
    func setBottomView() {
        memoLabel.text = note!.memo
        if memoLabel.text?.characters.count > 20  {
            let memoHeight = heightForView(memoLabel.text!, font: memoLabel.font, width: memoLabel.frame.width, lineSpacing:2)
        
            if memoHeight > MaxMemoHeight  {
                addBottomSpace(memoHeight - MaxMemoHeight)
            }
        }
    }
    
    func setEmotionLayer() {
        let emotionType = self.emotionMaker.getEmotionType((note!.emotion))
        setemoticonImage(emotionMaker.getDetailImagename(emotionType))
        topView.backgroundColor = emotionMaker.getEmotionColor(emotionType)
        emoticonMentLabel.text = emotionMaker.getDetailMent(emotionType)
    }
    
    func setDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
//        dateFormatter.dateFormat = "yyyy년 M월 dd일"
        let dateString = dateFormatter.string(from: note!.date as Date)
        noteDateLabel.text = dateString
    }
    
    func setDetailItems(_ note:Note) {
        
        var cardItemindex = 0
        if(note.hasPerson) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.person, itemText: getItemString(note.personName), itemIndex: cardItemindex))
        } else {
             addBlankitem(Detailtag(itemType: Detailtag.Tagtype.person, itemText: "", itemIndex: cardItemindex))
        }
        cardItemindex += 1
        if(note.hasItem) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.item, itemText: getItemString(note.itemName), itemIndex: cardItemindex))
            
        } else {
            addBlankitem(Detailtag(itemType: Detailtag.Tagtype.item, itemText: "", itemIndex: cardItemindex))
        }

        cardItemindex += 1
        
        if(note.hasActivity) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.activity, itemText: getItemString(note.activityName), itemIndex: cardItemindex))
        } else {
             addBlankitem(Detailtag(itemType: Detailtag.Tagtype.activity, itemText: "", itemIndex: cardItemindex))
        }
        
         cardItemindex += 1
        
        if(note.hasAnniversary) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.anniversary, itemText: getItemString(note.anniversaryName), itemIndex: cardItemindex))
        } else {
            addBlankitem(Detailtag(itemType: Detailtag.Tagtype.anniversary, itemText: "", itemIndex: cardItemindex))

        }
        cardItemindex += 1
        if(note.hasPlace) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.place, itemText: getItemString(note.placeName), itemIndex: cardItemindex))
           
        } else {
              addBlankitem(Detailtag(itemType: Detailtag.Tagtype.place, itemText: "", itemIndex: cardItemindex))
        }
         cardItemindex += 1
        
        while cardItemindex < 5 {
            clearDetailitem(cardItemindex)
            cardItemindex += 1
        }
    }
    
    func getItemString(_ data:String) ->(String){
        let endIndex = data.characters.count
        if(endIndex <= 30) {
            return data
        }
        return data.substring(with: (data.characters.index(data.startIndex, offsetBy: 0) ..< data.characters.index(data.endIndex, offsetBy: 30-endIndex))) + "..."
    }
    func clearDetailitem(_ index: Int) {
        if (index < itemLabels.count) {
            itemLabels[index].text = ""
        }
        if (index < itemIcons.count) {
            itemIcons[index].image = UIImage()
        }
    }

    func addDetailitem(_ tag: Detailtag){
        if (tag.index < itemLabels.count) {
            itemLabels[tag.index].text = tag.content
        }
        if (tag.index < itemIcons.count) {
            itemIcons[tag.index].image = UIImage(named: tag.getIconimageName())
        }
    }
    
    func addBlankitem(_ tag: Detailtag){
        if (tag.index < itemIcons.count) {
            itemLabels[tag.index].text = tag.content
            itemIcons[tag.index].image = alpha(UIImage(named: tag.getIconimageName())!, value: 0.4)
        }
    }
    
    func alpha(_ img:UIImage, value:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(img.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height);
        
        ctx?.scaleBy(x: 1, y: -1);
        ctx?.translateBy(x: 0, y: -area.size.height);
        ctx?.setBlendMode(.multiply);
        ctx?.setAlpha(value);
        ctx?.draw(img.cgImage!, in: area);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!;
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

    
    func heightForView(_ text:String, font:UIFont, width:CGFloat, lineSpacing:CGFloat) -> CGFloat{
        var label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label = setTextWithLineSpacing(label, text:label.text!, lineSpacing:lineSpacing)
        
        label.sizeToFit()
        return label.frame.height
    }

    
    func setTextWithLineSpacing(_ label:UILabel,text:String,lineSpacing:CGFloat) ->(UILabel){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        label.attributedText = attrString
        return label
    }
    
    
    
    func setemoticonImage(_ imgName: String ) {
        emoticonImage.image = UIImage(named: imgName)
    }

    
    func addBottomSpace(_ addValue :CGFloat) {
        self.scrollchildViewHeight.constant += addValue
        self.bottomStackViewHeight.constant += addValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateAllViews()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func OnCloseButton(_ sender: AnyObject) {
         dismiss(animated: false, completion: nil)
    }

    @IBAction func deleteNote(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("delete_message", comment: "message of alert view"), preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: "name of deleteButton"), style: .default, handler: {
            action in
                if let object = self.note {
                    try! self.realm.write {
                        self.realm.delete(object)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "name of cancelButton"), style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeNote = segue.destination as? WriteNoteViewController {
            writeNote.updateNoteId = getNoteId()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
