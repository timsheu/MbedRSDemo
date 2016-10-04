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
    @IBOutlet weak var switchButton: UISwitch?
    @IBOutlet weak var slider: UISlider?
    let TAG = "GreenSettingTableViewController: "
    let array = ["Temperature", "Illuminance", "Food"]
    var titleName: String = "Temperature"
    var resourceString: String = "/3303/0/5700"
    var valueLabel: UILabel?
    var onOff = "0"
    var sliderValue = "0"
    func setCustomTitle(name: String){
        self.titleName = name
    }
    //MARK: table view function
    override func viewDidLoad() {
        super.viewDidLoad()
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
        switchButton = cell.viewWithTag(102) as? UISwitch
        slider = cell.viewWithTag(103) as? UISlider
        slider?.minimumValue = 0.0
        slider?.value = 0.0
        slider?.maximumValue = 100.0
        settingTitle!.text = self.titleName
        if indexPath.row == 0 {
            label?.text = "Switch ON/OFF"
            slider!.hidden = true
        }else if indexPath.row == 1{
            valueLabel = label
            valueLabel?.text = "Reading..."
            switchButton!.hidden = true
        }
        
        // Configure the cell...

        return cell
    }
    
    @IBAction func turnOnOff(){
        let switchResource = judgeResourceString("Button")
        Mbedder.sharedInstance().setResourcePUT(switchResource, value: onOff)
    }
    
    @IBAction func sliderChanging(sender: UISlider){
        sliderValue = String(format: "%.0f", sender.value)
        self.valueLabel?.text = sliderValue
    }
    
    @IBAction func sliderChanged(sender: UISlider){
        let sliderResource = judgeResourceString("Slider")
        Mbedder.sharedInstance().setResourcePUT(sliderResource, value: String(format: "%.0f",sender.value))
    }
    
    //MARK: Mbedder delegate
    // POST is to activated the value, so any value would work
    func didPUTthenPOST(string: String) {
        Mbedder.sharedInstance().setResourcePOST(string, value: "0")
    }
    
    func updatingSliderValue(){
        print("\(TAG)updatingSliderValue")
        let resourceString = judgeResourceString("Slider")
        Mbedder.sharedInstance().openLongPolling(resourceString)
        Mbedder.sharedInstance().updateGreenStatus(resourceString)
    }
    
    func updatingButtonValue(){
        print("\(TAG)updatingButtonValue")
        let resourceString = judgeResourceString("Button")
        Mbedder.sharedInstance().openLongPolling(resourceString)
        Mbedder.sharedInstance().updateGreenStatus(resourceString)
    }
    
    func didUpdatedValue(value: String, resource: String) {
        print("\(TAG)didUpdatedValue: " + value)
        if value == "" {
            return
        }
        let sliderResource = judgeResourceString("Slider")
        if sliderResource == judgeResourceString("Button") {// food has same resource for slider and button
            self.onOff = value
            var onOffBool = true
            if value == "0" {
                self.onOff = value
                onOffBool = false
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.sliderValue = value
                self.slider?.value = Float(value)!
                self.valueLabel?.text = value
                self.switchButton?.on = onOffBool
            })
            return
        }
        if resource ==  sliderResource{
            dispatch_async(dispatch_get_main_queue(), {
                self.sliderValue = value
                self.slider?.value = Float(value)!
                self.valueLabel?.text = value
                self.updatingButtonValue()
            })
        }else{// if switch button value
            self.onOff = value
            var onOffBool = true
            if value == "0" {
                self.onOff = value
                onOffBool = false
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.switchButton?.on = onOffBool
            })
        }
        
    }
    
    func returnPayload(value: String, resource: String) {
        print("\(TAG): returnPayload: resource: \(resource), value: \(value)")
        if resource == judgeResourceString("Slider") || resource == judgeResourceString("Button"){
            didUpdatedValue(value, resource: resource)
        }
    }
    
    func returnStatus(string: String, resource: String) {
        if string == "200" {
            self.view.showToast("Set successful!", position: .Bottom, popTime: 2, dismissOnTap: false)
        }
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
            returnString = "/3302/0/5500"
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
