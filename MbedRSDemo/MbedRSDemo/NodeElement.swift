//
//  NodeElement.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/19/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import RestEssentials
class NodeElement: NSObject {
    var nodeName: String // custom name of the node
    let dataSerial: String // data serial number sent from mbed server
    let dataType: String // data type number sent from mbed server
    var value: String = "0" // data number in string
    var originData: RestEssentials.JSONObject
    
    init(nodeName: String, dataSerial: String, dataType: String, originData: RestEssentials.JSONObject) {
        self.nodeName = nodeName
        self.dataSerial = dataSerial
        self.dataType = dataType
        self.originData = originData
    }
}
