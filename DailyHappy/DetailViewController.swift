//
//  DetailViewController.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 3..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import UIKit
import RealmSwift


struct Detailtag {
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
            result = "DetailPerson"
        case .Place:
            result = "DetailPlace"
        case .Item:
            result = "DetailItem"
        case .Activity:
            result = "DetailActivity"
        case .Anniversary:
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
    
    @IBOutlet var scrollView: UIScrollView!
    
    private var itemLabels:[UILabel]=[]
    private var itemIcons:[UIImageView]=[]
    

    let realm = try! Realm()
    var id = 0
    var note: Note?
    let emotionMaker:EmotionMaker = EmotionMaker()
    let MaxMemoHeight = CGFloat(91)
    func setNoteId(id:Int) {
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
        border.backgroundColor =  UIColor(colorLiteralRed: 194.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1.0).CGColor
        border.frame = CGRectMake(0, middleView.frame.size.height - 1,   UIScreen.mainScreen().bounds.size.width - (scrollView.frame.size.width - middleView.frame.size.width), 1)
        middleView.layer.addSublayer(border)
        middleView.layer.zPosition = 1
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
        note = realm.objectForPrimaryKey(Note.self, key: getNoteId())
        
        setTitleLabel()
        setTopView()
        setMiddleView()
        setBottomView()
    }
    
    func setTitleLabel() {
        titleLabel.text = "상세보기"
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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월dd일"
        let dateString = dateFormatter.stringFromDate(note!.date)
        noteDateLabel.text = dateString
    }
    
    func setDetailItems(note:Note) {
        
        var cardItemindex = 0
        if(note.hasPerson) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.Person, itemText: getItemString(note.personName), itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasItem) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.Item, itemText: getItemString(note.itemName), itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasActivity) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.Activity, itemText: getItemString(note.activityName), itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasAnniversary) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.Anniversary, itemText: getItemString(note.anniversaryName), itemIndex: cardItemindex))
            cardItemindex++
        }
        if(note.hasPlace) {
            addDetailitem(Detailtag(itemType: Detailtag.Tagtype.Place, itemText: getItemString(note.placeName), itemIndex: cardItemindex))
            cardItemindex++
        }
        
        
        while cardItemindex < 5 {
            clearDetailitem(cardItemindex)
            cardItemindex++
        }
        
        
    }
    
    func getItemString(data:String) ->(String){
        let endIndex = data.characters.count
        if(endIndex <= 30) {
            return data
        }
        return data.substringWithRange(Range<String.Index>(start: data.startIndex.advancedBy(0), end: data.endIndex.advancedBy(30-endIndex))) + "..."
    }
    func clearDetailitem(index: Int) {
        if (index < itemLabels.count) {
            itemLabels[index].text = ""
        }
        if (index < itemIcons.count) {
            itemIcons[index].image = UIImage()
        }
    }

    func addDetailitem(tag: Detailtag){
        if (tag.index < itemLabels.count) {
            itemLabels[tag.index].text = tag.content
        }
        if (tag.index < itemIcons.count) {
            itemIcons[tag.index].image = UIImage(named: tag.getIconimageName())
        }
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

    
    func heightForView(text:String, font:UIFont, width:CGFloat, lineSpacing:CGFloat) -> CGFloat{
        var label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label = setTextWithLineSpacing(label, text:label.text!, lineSpacing:lineSpacing)
        
        label.sizeToFit()
        return label.frame.height
    }

    
    func setTextWithLineSpacing(label:UILabel,text:String,lineSpacing:CGFloat) ->(UILabel){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        label.attributedText = attrString
        return label
    }
    
    
    
    func setemoticonImage(imgName: String ) {
        emoticonImage.image = UIImage(named: imgName)
    }

    
    func addBottomSpace(addValue :CGFloat) {
        self.scrollchildViewHeight.constant += addValue
        self.bottomStackViewHeight.constant += addValue
    }
    
    override func viewWillAppear(animated: Bool) {
        updateAllViews()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func OnCloseButton(sender: AnyObject) {
         dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func deleteNote(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "지금 보고 계신 내용을 지우시겠습니까?", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .Default, handler: {
            action in
                if let object = self.note {
                    try! self.realm.write {
                        self.realm.delete(object)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .Cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let writeNote = segue.destinationViewController as? WriteNoteViewController {
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
