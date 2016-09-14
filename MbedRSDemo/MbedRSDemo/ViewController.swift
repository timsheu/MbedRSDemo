//
//  ViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/12/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import RestEssentials
import CocoaLumberjack
import EasyToast
class ViewController: UIViewController, MbedderDelegate {
    let mbedder = Mbedder.sharedInstance()
    
    @IBAction func connectMbed(sender: AnyObject) {
        self.view.showToast("Connecting Mbed server...", position: .Bottom, popTime: 3, dismissOnTap: false)
        mbedder.delegate = self
        mbedder.getEndName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mbedder delegate
    func didReadNode(){
        self.view.showToast("Retrieve node information successfully", position: .Bottom, popTime: 3, dismissOnTap: false)
        mbedder.getNodesList()
    }
    
    func didReadList() {
        self.view.showToast("Retrieve node list successfully", position: .Bottom, popTime: 3, dismissOnTap: false)
    }
}

