//
//  OrangeViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit

class OrangeViewController: UIViewController {
    var targetTitleString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showStatistic(sender: UIButton){
        switch sender.tag {
        case 20:
            targetTitleString = "Temperature"
            break
        case 21:
            targetTitleString = "Humidity"
            break
        case 22:
            targetTitleString = "Lux"
            break
        case 23:
            targetTitleString = "Activity"
            break
        default:
            targetTitleString = "Temperature"
            break
        }
        self.performSegueWithIdentifier("OrangeSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OrangeSegue" {
            let dest = segue.destinationViewController as? OrangeChartViewController
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
