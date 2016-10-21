//
//  ViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/12/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import ASToast
import CocoaLumberjack

class ViewController: UIViewController, MbedderDelegate {
    @IBOutlet var orangeButton: UIButton!
    @IBOutlet var greenButton: UIButton!
    @IBOutlet var segmentOutlet: UISegmentedControl!
    @IBAction func segment(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            mbedder.setupKey("Yb0jTruOSpFrnWXAwaFf9qzoJWdWFDaDTDuX3ZOAYVYxS0LPcpD5HANbHe5COCJET5kNGrE8UwZ4rAv6ZTNM5Ymx3Nw0IevLGtzQ")
        }else{
            mbedder.setupKey("IIqReRdjBniF67b3Ht4k2NnG8XE3hACSeouWeJlvHgY5iqOyrbmHs56oBpehwy4PdKciUne9IQf1IWc4HKXojxkXRI7790zsibuj")
        }
        
    }
    let mbedder = Mbedder.sharedInstance()
    
    @IBAction func connectMbed(_ sender: AnyObject) {
//        self.view.showToast("連接伺服器中", position: .Bottom, popTime: 3, dismissOnTap: true)
        self.view.makeToast("連接伺服器中", duration: 3, position: ASToastPosition.ASToastPositionBotom.rawValue as AnyObject?, backgroundColor: nil)
        mbedder.delegate = self
        mbedder.getEndName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let dummy = ""
//        connectMbed(dummy)
        greenButton.isEnabled = false
        orangeButton.isEnabled = false
        segmentOutlet.selectedSegmentIndex = 1
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
        self.view.makeToast("成功取得端點列表", duration: 3, position: ASToastPosition.ASToastPositionBotom.rawValue as AnyObject?, backgroundColor: nil)
    }
    
    func notReadingEnd() {
        self.view.makeToast("無資料！請檢查網路連線！", duration: 3, position: ASToastPosition.ASToastPositionBotom.rawValue as AnyObject?, backgroundColor: nil)
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
}

