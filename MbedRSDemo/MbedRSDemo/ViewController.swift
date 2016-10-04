//
//  ViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/12/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit

import CocoaLumberjack
import EasyToast
class ViewController: UIViewController, MbedderDelegate {
    @IBOutlet var orangeButton: UIButton!
    @IBOutlet var greenButton: UIButton!
    let mbedder = Mbedder.sharedInstance()
    
    @IBAction func connectMbed(sender: AnyObject) {
        self.view.showToast("連接伺服器...", position: .Bottom, popTime: 3, dismissOnTap: false)
        mbedder.delegate = self
        mbedder.getEndName()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dummy = ""
        connectMbed(dummy)
        greenButton.enabled = false
        orangeButton.enabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Mbedder delegate
    func didReadNode(){
        self.view.showToast("成功取得端點資訊", position: .Bottom, popTime: 3, dismissOnTap: false)
        mbedder.getNodesList()
    }
    
    func didReadList() {
        dispatch_async(dispatch_get_main_queue(), {
            self.greenButton.enabled = true
            self.orangeButton.enabled = true
        })
        self.view.showToast("成功取得端點列表", position: .Bottom, popTime: 3, dismissOnTap: false)
    }
    
    func notReadingEnd() {
        self.view.showToast("無資料！請檢查網路連線！", position: .Bottom, popTime: 3, dismissOnTap: false)
    }
    
    func didUpdatedValue(string: String, resource: String) {
        //not used here
    }
    
    func didPUTthenPOST(resource: String) {
        //not used here
    }
    
    
    func returnPayload(string: String, resource: String) {
        //not used here
    }
    
    func returnStatus(string: String, resource: String) {
        //not used here
    }
}

