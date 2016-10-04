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
    func notReadingEnd()
    func didReadNode()
    func didReadList()
    func returnPayload(value: String, resource: String)
    func returnStatus(status: String, resource: String)
    func didPUTthenPOST(resource: String)
    func didUpdatedValue(value: String, resource: String)
}

class Mbedder: NSObject {
    let TAG = "Mbedder: "
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
            print("\(TAG)Bad URL during init with value: " + basicList)
            return
        }
        
        rest.get(nil, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                self.endName = json.jsonArray![0]?.jsonObject?["name"]?.stringValue
                if self.endName != nil {
                    print("\(self.TAG)device name: " + self.endName!)
                    self.delegate?.didReadNode()
                }else{
                    
                }
            }catch{
                print("\(self.TAG)Error performing GET \(error)")
            }
        }
    }
    
    internal func getNodesList(){
        let listNodes = basicList + "/" + self.endName!
        
        guard let rest = RestController.createFromURLString(listNodes) else{
            print("\(TAG)Bad URL during init with value: " + listNodes)
            return
        }
        
        rest.get(nil, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                let nodesArray = json.jsonArray!
                for (index, element) in nodesArray.enumerate(){
                    print("\(self.TAG)index: \(index), element: \(element.jsonObject?["uri"]))")
                    let uri = element.jsonObject?["uri"]?.stringValue
                    let (sensorType, dataNumber, dataType) = self.resolveNameFromURI(uri!)
                    if sensorType == "" || dataNumber == "" || dataType == ""{
                        continue
                    }
                    let nodeElement = NodeElement(nodeName: sensorType, dataSerial: dataNumber, dataType: dataType, originData: element.jsonObject!)
                    self.endNodes.setValue(nodeElement, forKey: dataNumber)
                }
                self.delegate?.didReadList()
            }catch{
                print("\(self.TAG)Error performing getlist GET \(error)")
            }
        }
    }
    
    internal func resolveNameFromURI(uri: String) -> (String, String, String){
        
        var splitArray = uri.characters.split{$0 == "/"}.map(String.init)
        let dataNumber = splitArray[0]
        var sensorType: String?
        if splitArray.count < 3 {
            return ("", "", "")
        }
        switch splitArray[0] {
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
            print("\(TAG)resolve name: default")
            sensorType = "NONE"
            break;
        }
        
        var dataType: String?
        switch splitArray[2] {
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
        
        return (sensorType!, dataNumber, dataType!)
    }
    
    internal func getNodeValue(dataNumber: String){
        openLongPolling("")
        let listNodes = basicList + "/" + self.endName! + dataNumber + "/"
        print("\(TAG)getNodeValue: " + listNodes)
        guard let rest = RestController.createFromURLString(listNodes) else{
            print("\(TAG)Bad URL during init with value: " + listNodes)
            return
        }
        rest.get(nil, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                print("\(self.TAG)response: \(json)")
            }catch{
                print("\(self.TAG)Error performing getNodeValue GET \(error), httpResponse: \(httpResponse), result: \(result)")
            }
        }
    }
    
    func openLongPolling(resource: String){
        let listNodes = "https://api.connector.mbed.com/notification/pull"
        
        guard let rest = RestController.createFromURLString(listNodes) else{
            print("\(TAG)Bad URL during init with value: " + listNodes)
            return
        }
        
        var localOption = RestOptions.init()
        localOption.httpHeaders = ["Authorization": authKey, "Connection" : "keep-alive"]
        rest.get(nil, withOptions: localOption){ result, httpResponse in
            do{
                let json = try result.value()
//                print("\(self.TAG)openLongPolling: json: \(json)")
                if let asyncJson = json.jsonObject!["async-responses"]{
                    if let jsonArray = asyncJson.jsonArray![0]{
                        print("\(self.TAG)openLongPolling: json: \(jsonArray)")
                        if let base64String = jsonArray["payload"]?.stringValue{
                            let payload = self.base64StringToString(base64String)
                            print("\(self.TAG)openLongPolling, base64: \(base64String) payload: \(payload)")
                            self.delegate?.returnPayload(payload, resource: resource)
                        }
                        if let statusString = jsonArray["status"]?.stringValue{
                            print("\(self.TAG)openLongPolling, status: \(statusString)")
                            self.delegate?.returnStatus(statusString, resource: resource)
                        }
                    }else if let jsonValue = asyncJson.jsonObject{
                        print("\(self.TAG)jsonValue: \(jsonValue)")
                    }
                    
                }
            }catch{
                print("\(self.TAG)Error performing openLongPolling GET \(error), httpResponse: \(httpResponse), result: \(result)")
                print("%@", LWM2MID_DIGI_OUT)
            }
        }
    }
    
    func setResourcePUT(resource: String, value: String){
        let PUTNodes = basicList + "/" + self.endName! + resource
        print("\(TAG)PUTNodes: \(PUTNodes)")
        guard let rest = RestController.createFromURLString(PUTNodes) else{
            print("\(TAG)Bad URL during init with value: " + PUTNodes)
            return
        }
        
        var localOption = RestOptions.init()
        localOption.httpHeaders = ["Authorization": authKey]
        let data = 	value.dataUsingEncoding(NSUTF8StringEncoding)
        rest.put(nil, withData: data!, withOptions: localOption){ result, httpResponse in
            do{
                let json = try result.value()
                if let id = json.jsonObject!["async-response-id"]{
                    print("\(self.TAG)PUT: \(id)")
                    self.delegate?.didPUTthenPOST(resource)
                }
                
            }catch{
                print("\(self.TAG)Error performing PUT \(error)")
            }
        }
    }
    
    func setResourcePOST(resource: String, value: String){
        let listNodes = basicList + "/" + self.endName! + resource
        
        guard let rest = RestController.createFromURLString(listNodes) else{
            print("\(TAG)Bad URL during init with value: " + listNodes)
            return
        }
        let data = 	value.dataUsingEncoding(NSUTF8StringEncoding)
        
        rest.post(nil, withNSData: data!, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                if let id = json.jsonObject!["async-response-id"]{
                    print("\(self.TAG)POST: id:\(id)")
                    
                }
            }catch{
                print("\(self.TAG)Error performing POST \(error)")
            }
        }
    }
    
    func updateGreenStatus(resource: String){
        let listNodes = basicList + "/" + self.endName! + resource + "/"
            print("\(TAG)updateGreenStatus: " + listNodes)
        guard let rest = RestController.createFromURLString(listNodes) else{
            print("\(TAG)Bad URL during init with value: " + listNodes)
            return
        }
        
        rest.get(nil, withOptions: self.option!){ result, httpResponse in
            do{
                let json = try result.value()
                print("\(self.TAG)updateGreenStatus: \(json)")
            }catch{
                print("\(self.TAG)Error performing updateGreenStatus \(error)")
            }
        }
    }
    
    
    
    //MARK: utility
    func base64StringToString(string: String) -> String {
        var result: String?
        let decodedData = NSData(base64EncodedString: string, options: .IgnoreUnknownCharacters)
        result = String(data: decodedData!, encoding: NSUTF8StringEncoding)

        return result!
    }
}
