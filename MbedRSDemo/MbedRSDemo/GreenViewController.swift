//
//  GreenViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit

class GreenViewController: UIViewController {
    var targetTitleString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goSetting(sender: UIButton){
        switch sender.tag {
        case 10:
            targetTitleString = "Temperature"
            break;
        case 11:
            targetTitleString = "Illuminance"
            break;
        case 12:
            targetTitleString = "Food"
            break;
            
        default:
            break;
        }
        self.performSegueWithIdentifier("GreenSegue", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GreenSegue" {
            let dest = segue.destinationViewController as? GreenSettingTableViewController
            dest?.setCustomTitle(targetTitleString!)
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
