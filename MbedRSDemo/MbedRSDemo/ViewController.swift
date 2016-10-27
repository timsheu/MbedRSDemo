//
//  ViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/12/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import CocoaLumberjack
import Toaster
class ViewController: UIViewController, MbedderDelegate {
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var orangeButton: UIButton!
    @IBOutlet var greenButton: UIButton!
    @IBOutlet var segmentOutlet: UISegmentedControl!
    @IBAction func segment(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            mbedder.setupKey("Yb0jTruOSpFrnWXAwaFf9qzoJWdWFDaDTDuX3ZOAYVYxS0LPcpD5HANbHe5COCJET5kNGrE8UwZ4rAv6ZTNM5Ymx3Nw0IevLGtzQ")
        }else if sender.selectedSegmentIndex == 1{
            mbedder.setupKey("IIqReRdjBniF67b3Ht4k2NnG8XE3hACSeouWeJlvHgY5iqOyrbmHs56oBpehwy4PdKciUne9IQf1IWc4HKXojxkXRI7790zsibuj")
        }else {
            mbedder.setupKey("Bw2GI9DBxhcxLahcOQO4mWChfX6UIH4BH8y8cIqtTaUJN0wWHDqWkaovxNM47bQnizV2qgeZXMgb4Nb84txgsXAqcA2U7QM5nlX3")
        }
        
    }
    let mbedder = Mbedder.sharedInstance()
    
    @IBAction func connectMbed(_ sender: AnyObject) {
        connectButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.unlockButtonTimer), userInfo: nil, repeats: false)
        Toast(text: "連接伺服器中", duration: Delay.short).show()
        mbedder.delegate = self
        mbedder.getEndName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let dummy = ""
//        connectMbed(dummy)
        greenButton.isEnabled = false
        orangeButton.isEnabled = false
        segmentOutlet.selectedSegmentIndex = 2
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Mbedder delegate
    func didReadNode(){
        mbedder.getNodesList()
    }
    
    func didReadList() {
        DispatchQueue.main.async(execute: {
            self.greenButton.isEnabled = true
            self.orangeButton.isEnabled = true
        })
        Toast(text: "成功取得端點列表", duration: Delay.short).show()
        connectButton.isEnabled = true
    }
    
    func notReadingEnd() {
        Toast(text: "無資料！請檢查網路連線！", duration: Delay.short).show()
    }
    
    func didUpdatedValue(_ string: String, resource: String) {
        //not used here
    }
    
    func didPUTthenPOST(_ resource: String) {
        //not used here
    }
    
    
    func returnPayload(_ string: String, resource: String) {
        //not used here
    }
    
    func returnStatus(_ string: String, resource: String) {
        //not used here
    }
    
    func returnNotificationaFromServer(_ content: NSDictionary) {
        //not used here
    }
    
    //MARK: unlockButton timer
    func unlockButtonTimer(){
        unlockButton(button: connectButton, option: true)
    }
    
    func unlockButton(button: UIButton?, option: Bool){
        if button != nil{
            button?.isEnabled = option
        }
    }
}

