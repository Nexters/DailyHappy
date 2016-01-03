//
//  DetailViewController.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 3..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var id = 0
    
    func setNoteId(id:Int) {
        self.id = id
    }
    
    func getNoteId() ->(Int) {
        return id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)

        // Do any additional setup after loading the view.
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnCloseButton(sender: AnyObject) {
         dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func deleteNotr(sender: UIButton) {
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
