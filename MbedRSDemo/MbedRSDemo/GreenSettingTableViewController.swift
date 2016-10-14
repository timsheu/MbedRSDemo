//
//  GreenSettingTableViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit

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
    var timer: NSTimer?
    var resource: String?
    var count = 0
    func setCustomTitle(name: String){
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let label = cell.viewWithTag(101) as? UILabel
        let localButton = cell.viewWithTag(102) as! UISwitch
        let localSlider = cell.viewWithTag(103) as! UISlider
        localSlider.hidden = true
        localButton.hidden = true
        settingTitle!.text = self.titleName
        if indexPath.row == 0 {
            switchButton = localButton
            switchButton.hidden = false
            label?.text = "Switch ON/OFF"
        }else if indexPath.row == 1{
            slider = localSlider
            slider.hidden = false
            slider?.minimumValue = 0.0
            slider?.value = 0.0
            slider?.maximumValue = 100.0
            valueLabel = label
            valueLabel?.text = "Reading..."
        }
        
        // Configure the cell...

        return cell
    }
    
    @IBAction func turnOnOff(sender: UISwitch){
        var onoff = "1"
        if sender.on == false {
            onoff = "0"
        }
        Mbedder.sharedInstance().setResourcePUT(resourceButtonString, value: onoff)
    }
    
    @IBAction func sliderChanging(sender: UISlider){
        sliderValue = String(format: "%.0f", sender.value)
        self.valueLabel?.text = sliderValue
    }
    
    @IBAction func sliderChanged(sender: UISlider){
        let onoff = (sender.value > 0) ? true : false
        if resourceSliderString == resourceButtonString {
            switchButton.setOn(onoff, animated: true)
        }
        Mbedder.sharedInstance().setResourcePUT(resourceSliderString, value: String(format: "%.0f",sender.value))
    }
    
    //MARK: Mbedder delegate
    // POST is to activated the value, so any value would work
    func didPUTthenPOST(string: String) {
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
    
    func didUpdatedValue(value: String, resource: String) {
        print("\(TAG)didUpdatedValue: " + value)
    }
    
    func returnPayload(value: String, resource: String) {
        print("\(TAG): returnPayload: resource: \(resource), value: \(value)")
    }
    
    func returnStatus(string: String, resource: String) {
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
    
    func returnNotificationaFromServer(content: NSDictionary) {
        print("\(TAG)returnNotificationaFromServer:")
        var isResponse = false
        if let asyncResponse = content["async-response"] {
            print("\(TAG) async-response")
            if asyncResponse["id"] as! String == resourceSliderString{
                resource = resourceSliderString
                if let payload = asyncResponse["payload"] as? String {
                    isResponse = true
                    print("\(TAG) id: \(resourceSliderString), payload: \(payload)")
                    let value = Float(payload)
                    dispatch_async(dispatch_get_main_queue(), {
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
            }else if asyncResponse["id"] as! String == resourceButtonString{
                resource = resourceButtonString
                if let payload = asyncResponse["payload"] as? String{
                    isResponse = true
                    print("\(TAG) id: \(resourceButtonString), payload: \(payload)")
                    let value = (Int(payload) > 0) ? true : false
                    dispatch_async(dispatch_get_main_queue(), {
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
            dispatch_async(dispatch_get_main_queue(), {
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(GreenSettingTableViewController.timerPolling), userInfo: self.resource, repeats: false)
                if self.count == 10 {
                    self.view.showToast("伺服器忙碌，無法更新頁面數值，但仍可修改數值", position: .Bottom, popTime: 10, dismissOnTap: true)
                } else if self.count == 2 {
                    self.view.showToast("連線困難，持續嘗試中", position: .Bottom, popTime: 3, dismissOnTap: true)
                }
            })
            
        }
    }
    
    //MARK: utilities
    private func judgeResourceString(type: String) -> String{
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
    
    func timerPolling(timer: NSTimer){
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
