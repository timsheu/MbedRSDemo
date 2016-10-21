//
//  GreenSettingTableViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import ASToast
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GreenSettingTableViewController: UITableViewController, MbedderDelegate {
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var slider: UISlider!
    let TAG = "GreenSettingTableViewController: "
    let array = ["Temperature", "Illuminance", "Food"]
    var titleName: String = "Temperature"
    var resourceSliderString = "/3308/0/5900"
    var resourceButtonString = "/3308/0/5850"
    var valueLabel: UILabel?
    var onOff = "0"
    var sliderValue = "0"
    var timer: Timer?
    var resource: String?
    var count = 0
    func setCustomTitle(_ name: String){
        self.titleName = name
    }
    //MARK: table view function
    override func viewDidLoad() {
        super.viewDidLoad()
        resourceSliderString = judgeResourceString("Slider")
        resourceButtonString = judgeResourceString("Button")
        Mbedder.sharedInstance().delegate = self
        updatingSliderValue()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let label = cell.viewWithTag(101) as? UILabel
        let localButton = cell.viewWithTag(102) as! UISwitch
        let localSlider = cell.viewWithTag(103) as! UISlider
        localSlider.isHidden = true
        localButton.isHidden = true
        settingTitle!.text = self.titleName
        if (indexPath as NSIndexPath).row == 0 {
            switchButton = localButton
            switchButton.isHidden = false
            label?.text = "Switch ON/OFF"
        }else if (indexPath as NSIndexPath).row == 1{
            slider = localSlider
            slider.isHidden = false
            slider?.minimumValue = 0.0
            slider?.value = 0.0
            slider?.maximumValue = 100.0
            valueLabel = label
            valueLabel?.text = "Reading..."
        }
        
        // Configure the cell...

        return cell
    }
    
    @IBAction func turnOnOff(_ sender: UISwitch){
        var onoff = "1"
        if sender.isOn == false {
            onoff = "0"
        }
        Mbedder.sharedInstance().setResourcePUT(resourceButtonString, value: onoff)
    }
    
    @IBAction func sliderChanging(_ sender: UISlider){
        sliderValue = String(format: "%.0f", sender.value)
        self.valueLabel?.text = sliderValue
    }
    
    @IBAction func sliderChanged(_ sender: UISlider){
        let onoff = (sender.value > 0) ? true : false
        if resourceSliderString == resourceButtonString {
            switchButton.setOn(onoff, animated: true)
        }
        Mbedder.sharedInstance().setResourcePUT(resourceSliderString, value: String(format: "%.0f",sender.value))
    }
    
    //MARK: Mbedder delegate
    // POST is to activated the value, so any value would work
    func didPUTthenPOST(_ string: String) {
        Mbedder.sharedInstance().setResourcePOST(string, value: "0")
    }
    
    func updatingSliderValue(){
        print("\(TAG)updatingSliderValue")
        resource = resourceSliderString
        Mbedder.sharedInstance().openLongPolling(resourceSliderString)
        Mbedder.sharedInstance().updateGreenStatus(resourceSliderString)
    }
    
    func updatingButtonValue(){
        print("\(TAG)updatingButtonValue")
        resource = resourceButtonString
        Mbedder.sharedInstance().openLongPolling(resourceButtonString)
        Mbedder.sharedInstance().updateGreenStatus(resourceButtonString)
    }
    
    func didUpdatedValue(_ value: String, resource: String) {
        print("\(TAG)didUpdatedValue: " + value)
    }
    
    func returnPayload(_ value: String, resource: String) {
        print("\(TAG): returnPayload: resource: \(resource), value: \(value)")
    }
    
    func returnStatus(_ string: String, resource: String) {
    }
    
    func didReadList() {
        //not used here
    }
    
    func didReadNode() {
        //not used here
    }
    
    func notReadingEnd() {
        //not used here
    }
    
    func returnNotificationaFromServer(_ content: NSDictionary) {
        print("\(TAG)returnNotificationaFromServer:")
        var isResponse = false
        if let asyncResponse = content["async-response"] as? [String: String] {
            print("\(TAG) async-response")
            if asyncResponse["id"]! as String == resourceSliderString{
                resource = resourceSliderString
                if let payload = asyncResponse["payload"]{
                    isResponse = true
                    print("\(TAG) id: \(resourceSliderString), payload: \(payload)")
                    let value = Float(payload)
                    DispatchQueue.main.async(execute: {
                        self.slider?.value = value!
                        self.valueLabel?.text = String(format: "%.0f", value!)
                        self.count = 0
                        if self.resourceButtonString == self.resourceSliderString {
                            let onoff = ( value > 0) ? true : false
                            self.switchButton.setOn(onoff, animated: true)
                        }else{
                            self.updatingButtonValue()
                        }
                    })
                    
                }
            }else if asyncResponse["id"] == resourceButtonString{
                resource = resourceButtonString
                if let payload = asyncResponse["payload"]{
                    isResponse = true
                    print("\(TAG) id: \(resourceButtonString), payload: \(payload)")
                    let value = (Int(payload) > 0) ? true : false
                    DispatchQueue.main.async(execute: {
                        self.switchButton?.setOn(value, animated: true)
                        self.count = 0
                    })
                    if self.valueLabel?.text == "Reading..." {
                        self.updatingSliderValue()
                    }
                }
            }else{
//                self.updatingSliderValue()
            }
        }
        if content["reg-updates"] != nil {
            print("\(TAG) reg-updates")
        }
        if isResponse == false {
            count += 1
            print("\(TAG) no response")
            DispatchQueue.main.async(execute: {
                Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GreenSettingTableViewController.timerPolling), userInfo: self.resource, repeats: false)
                if self.count == 10 {
                    self.view.makeToast("伺服器忙碌，無法更新頁面數值，但仍可修改數值", duration: 3, position: ASToastPosition.ASToastPositionBotom.rawValue as AnyObject?, backgroundColor: nil)
                } else if self.count == 2 {
                    self.view.makeToast("連線困難，持續嘗試中", duration: 3, position: ASToastPosition.ASToastPositionBotom.rawValue as AnyObject?, backgroundColor: nil)
                }
            })
            
        }
    }
    
    //MARK: utilities
    fileprivate func judgeResourceString(_ type: String) -> String{
        var returnString = "/3308/0/5900"
        switch self.titleName {
        case "Temperature":
            if type == "Button" {
                returnString = "/3308/0/5850"
            }else{
                returnString = "/3308/0/5900"
            }
            break
        case "Illuminance":
            if type == "Button" {
                returnString = "/3311/0/5850"
            }else{
                returnString = "/3311/0/5851"
            }
            break
        case "Food":
            returnString = "/3343/0/5851"
            break
        default:
            if type == "Button" {
                returnString = ""
            }else{
                returnString = "/3303/0/5700"
            }
            break
        }
        return returnString
    }
    
    func timerPolling(_ timer: Timer){
        let resource = timer.userInfo as! String
        Mbedder.sharedInstance().openLongPolling(resource)
        Mbedder.sharedInstance().updateGreenStatus(resource)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
