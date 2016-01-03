//
//  DetailViewController.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 3..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    let realm = try! Realm()
    var id = 0
    var note: Note?
    
    func setNoteId(id:Int) {
        self.id = id
    }
    
    func getNoteId() ->(Int) {
        return id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        note = realm.objectForPrimaryKey(Note.self, key: getNoteId())

        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func OnCloseButton(sender: AnyObject) {
         dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func deleteNote(sender: UIButton) {
        if let object = note {
            try! realm.write {
                realm.delete(object)
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
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
