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

class ViewController: UIViewController {
    let mbedServer = "https://api.connector.mbed.com/endpoints"
    let authKey = "Bearer Yb0jTruOSpFrnWXAwaFf9qzoJWdWFDaDTDuX3ZOAYVYxS0LPcpD5HANbHe5COCJET5kNGrE8UwZ4rAv6ZTNM5Ymx3Nw0IevLGtzQ"
    
    @IBAction func connectMbed(sender: AnyObject) {
        guard let rest = RestController.createFromURLString(mbedServer) else {
            print("Bad URL")
            return
        }
        var option = RestOptions.init()
        option.httpHeaders = ["Authorization": authKey]
        rest.get(nil, withOptions: option){ result, httpResponse in
            do{
                let json = try result.value()
                print(json)
            }catch{
                print("Error performing GET \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

