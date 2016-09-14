//
//  Mbedder.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import RestEssentials
import CocoaLumberjack

protocol MbedderDelegate {
    func didReadNode()
    func didReadList()
}
class Mbedder: NSObject {
    //delegate
    var delegate: MbedderDelegate?
    var dateSource: MbedderDelegate?
    
    //variables and constants
    let basicList = "https://api.connector.mbed.com/endpoints"
    let authKey = "Bearer Yb0jTruOSpFrnWXAwaFf9qzoJWdWFDaDTDuX3ZOAYVYxS0LPcpD5HANbHe5COCJET5kNGrE8UwZ4rAv6ZTNM5Ymx3Nw0IevLGtzQ"
    var endName: String?
    var endNodes: NSMutableDictionary = [:]
    var option: RestOptions?
    
    //shared instance setup
    private static var mInstance:Mbedder?
    static func sharedInstance() -> Mbedder{
        if mInstance == nil {
            mInstance = Mbedder()
        }
        return mInstance!
    }
    
    private override init(){
        self.option = RestOptions.init()
        self.option!.httpHeaders = ["Authorization": authKey]
    }
    
    //mbed control functions
    internal func getEndName(){
        guard let rest = RestController.createFromURLString(basicList) else{
            print("Bad URL during init with value: " + basicList)
            return
        }
        
        rest.get(nil, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                self.endName = json.jsonArray![0]?.jsonObject?["name"]?.stringValue
                print("device name: " + self.endName!)
                self.delegate?.didReadNode()
            }catch{
                print("Error performing GET \(error)")
            }
        }
    }
    
    internal func getNodesList(){
        let listNodes = basicList + "/" + self.endName!
        
        guard let rest = RestController.createFromURLString(listNodes) else{
            print("Bad URL during init with value: " + listNodes)
            return
        }
        
        rest.get(nil, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                let nodesArray = json.jsonArray!
                for (index, element) in nodesArray.enumerate(){
                    print("index: \(index), element: \(element.jsonObject?["uri"]))")
                    let uri = element.jsonObject?["uri"]?.stringValue
                    let uriArray = uri!.characters.split{$0 == "/"}.map(String.init)
                    let nodeNumber = uriArray[1]
                    self.endNodes.setValue(nodeNumber, forKey: (element.jsonObject?["uri"]?.stringValue)!)
                    self.delegate?.didReadList()
                }
            }catch{
                print("Error perfroming GET \(error)")
            }
        }
    }
    
    internal func resolveNameFromURI(uri: String) -> NSMutableDictionary{
        let dict: NSMutableDictionary = [:]
        var splitArray = uri.characters.split{$0 == "/"}.map(String.init)
        var sensorType: String?
        switch splitArray[1] {
        case lwm2m_id.LWM2MID_GAS_LEVEL:
            sensorType = "LWM2MID_GAS_LEVEL"
            break;
        case lwm2m_id.LWM2MID_VIBRATION:
            sensorType = "LWM2MID_VIBRATION"
            break;
        case lwm2m_id.LWM2MID_HUMIDITY:
            sensorType = "LWM2MID_HUMIDITY"
            break;
        case lwm2m_id.LWM2MID_TEMPERATURE:
            sensorType = "LWM2MID_TEMPERATURE"
            break;
        case lwm2m_id.LWM2MID_DIGI_OUT:
            sensorType = "LWM2MID_DIGI_OUT"
            break;
        case lwm2m_id.LWM2MID_DIGI_IN:
            sensorType = "LWM2MID_DIGI_IN"
            break;
        default:
            print("resolve name: default")
            sensorType = "NONE"
            break;
        }
        dict.setValue(sensorType, forKey: "sensorType")
        
        var dataType: String?
        switch splitArray[3] {
        case lwm2m_id.LWM2MID_DIGI_IN_STATE:
            dataType = "unknown"
            break;
        case lwm2m_id.LWM2MID_SENSOR_VAL:
            dataType = "float"
            break;
        case lwm2m_id.LWM2MID_SENSOR_UNIT:
            dataType = "string"
            break;
        case lwm2m_id.LWM2MID_X_VAL:
            dataType = "float"
            break;
        case lwm2m_id.LWM2MID_Y_VAL:
            dataType = "float"
            break;
        case lwm2m_id.LWM2MID_Z_VAL:
            dataType = "float"
            break;
        case lwm2m_id.LWM2MID_COLOUR:
            dataType = "color"
            break;
        default:
            dataType = "unknown"
        }
        
        dict.setValue(dataType, forKey: "dataType")
        return dict
    }
    
}