//
//  OrangeChartViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import Charts

class OrangeChartViewController: UIViewController, ChartViewDelegate, MbedderDelegate {
    let TAG = "OrangeChartVC: "
    var time = ["N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A"]
    var values = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var timer: Timer?
    var titleName: String?
    var resourceString = "/3303/0/5700"
    var count = 0
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet weak var lineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = titleName
        setupLineCharts()
        Mbedder.sharedInstance().delegate = self
        Mbedder.sharedInstance().openLongPolling("")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    func setCustomTitle(_ title: String) {
        self.titleName = title
    }
    //MARK: Charts functions
    func setupLineCharts(){
        lineChart?.delegate = self
        lineChart?.chartDescription?.text = titleName!
        lineChart?.noDataText = "Data coming in, please wait!"
        lineChart?.dragEnabled = true
        lineChart?.setScaleEnabled(false)
        lineChart?.pinchZoomEnabled = true
        lineChart?.drawGridBackgroundEnabled = true
        lineChart?.xAxis.gridLineWidth = 1.0
        
        lineChart?.legend.form = Legend.Form.line
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(OrangeChartViewController.setChartsTimer(_:)), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    
    func setChartsTimer(_ timer: Timer){
        mbedderGetNodeValue()
    }
    
    func setCharts(){
        var demoDataEntries: [ChartDataEntry] = []
        for i in 0..<time.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            demoDataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(values: demoDataEntries, label: "value")
        lineChartDataSet.highlightLineDashLengths = [5.0, 2.5]
        lineChartDataSet.setColor(UIColor.black)
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 3.0
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.valueFont = UIFont.systemFont(ofSize: 9.0)
        lineChartDataSet.lineDashLengths = [5.0, 5.0]
        lineChartDataSet.lineWidth = 1.0
        
//        let lineChartData = LineChartData(xVals: time, dataSet: lineChartDataSet)
        lineChart.data = LineChartData(dataSet: lineChartDataSet)
    }
    //MARK: random number
    func changeData(_ string: String){
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.NSMinuteCalendarUnit, .NSSecondCalendarUnit], from: date)
        let currentTime = String(format: "%02d", components.minute!) + ":" + String(format: "%02d", components.second!)
        print("\(TAG)Current Time: " + currentTime)
        time.removeFirst()
        time.append(currentTime)
        values.removeFirst()
        if string == "" {
            let random = Double(arc4random_uniform(15) + 1)
            values.append(random)
            print("\(TAG)random: \(random)")
        }else{
            values.append(Double(string)!)
        }
        DispatchQueue.main.async(execute: {
            self.setCharts()
        })
    }
    
    //MARK: Mbedder functions
    func pollingData(){
        print("\(TAG)polling Data:")
        let mbedder = Mbedder.sharedInstance()
        mbedder.delegate = self
    }

    //Mbedder delegate
    func didReadNode(){
        //not used here
    }
    
    func didReadList() {
        //not used here
    }
    
    func didPUTthenPOST(_ resource: String) {
        //not used here
    }
    
    func didUpdatedValue(_ string: String, resource: String) {
        //not used here
    }
    
    func mbedderGetNodeValue() {
        print("\(TAG)mbedderGetNodeValue:")
        switch self.titleName {
        case "Temperature"?:
            resourceString = "/3303/0/5700"
            break
        case "Humidity"?:
            resourceString = "/3304/0/5700"
            break
        case "Illuminance"?:
            resourceString = "/3301/0/5700"
            break
        case "Activity"?:
            resourceString = "/3302/0/5500"
            break
        default:
            resourceString = "/3303/0/5700"
            break
        }
        Mbedder.sharedInstance().getNodeValue(self.resourceString)
    }
    
    func returnPayload(_ string: String, resource: String) {
        print("\(TAG)returnPayload:")
    }
    
    func returnStatus(_ string: String, resource: String) {
        print("\(TAG)returnStatus: \(string)")
    }
    
    func notReadingEnd() {
        //not used here
    }
    
    func returnNotificationaFromServer(_ content: NSDictionary) {
        print("\(TAG)returnNotificationaFromServer:")
        if let asyncResponse = content["async-response"] as? [String: String] {
            if asyncResponse["id"] == resourceString{
                let payload = asyncResponse["payload"]
                print("\(TAG) id: \(resourceString), payload: \(payload)")
                changeData(payload!)
                count = 0
            }
        }
        if content["reg-updates"] != nil {
            print("\(TAG) reg-updates")
        }
        count += 1
        DispatchQueue.main.async(execute: {

            if self.count == 5{
                
//                self.view.showToast("連線困難，持續嘗試中", position: .Bottom, popTime: 5, dismissOnTap: true)
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
