//
//  SelectMonthViewController.swift
//  DailyHappy
//
//  Created by seokjoong on 2016. 1. 1..
//  Copyright © 2016년 TeamNexters. All rights reserved.
//

import UIKit

class SelectMonthViewController: UIViewController {

    @IBOutlet weak var selectMonthStackView: SelectMonthStackView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    
    @IBOutlet var JanButton: MKButton!
    @IBOutlet var AprButton: MKButton!
    @IBOutlet var JulButton: MKButton!
    @IBOutlet var OctButton: MKButton!

    @IBOutlet var FebButton: MKButton!
    @IBOutlet var MayButton: MKButton!
    @IBOutlet var AugButton: MKButton!
    @IBOutlet var NovButton: MKButton!

    @IBOutlet var MarButton: MKButton!
    @IBOutlet var JunButton: MKButton!
    @IBOutlet var SepButton: MKButton!
    @IBOutlet var DecButton: MKButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        // Do any additional setup after loading the view.
        selectMonthStackView.backgroundColor = UIColor.clearColor()
        leftView.backgroundColor = UIColor.clearColor()
        centerView.backgroundColor = UIColor.clearColor()
        rightView.backgroundColor = UIColor.clearColor()
        
        
    }
    func initBackground() {
        let backimg = UIImage(named: "BackgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backimg!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func OnJanButton(sender: AnyObject) {
        
        
    }
    @IBAction func OnAprButton(sender: AnyObject) {
    }
    @IBAction func OnJulButton(sender: AnyObject) {
    }
    @IBAction func OnOctButton(sender: AnyObject) {
    }
    
    @IBAction func OnFebButton(sender: AnyObject) {
    }
    @IBAction func OnMayButton(sender: AnyObject) {
    }
    @IBAction func OnAugButton(sender: AnyObject) {
    }
    @IBAction func OnNovButton(sender: AnyObject) {
    }

    @IBAction func OnMarButton(sender: AnyObject) {
    }
    @IBAction func OnJubButton(sender: AnyObject) {
    }
    @IBAction func OnSepButton(sender: AnyObject) {
    }
    @IBAction func OnDecButton(sender: AnyObject) {
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
