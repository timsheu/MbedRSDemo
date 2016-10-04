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
    var timer: NSTimer?
    var titleName: String?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet weak var lineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = titleName
        setupLineCharts()
        Mbedder.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timer?.invalidate()
    }
    
    func setCustomTitle(title: String) {
        self.titleName = title
    }
    //MARK: Charts functions
    func setupLineCharts(){
        lineChart?.delegate = self
        lineChart?.descriptionText = titleName!
        lineChart?.noDataTextDescription = "Data coming in, please wait!"
        lineChart?.dragEnabled = true
        lineChart?.setScaleEnabled(false)
        lineChart?.pinchZoomEnabled = true
        lineChart?.drawGridBackgroundEnabled = true
        lineChart?.xAxis.gridLineWidth = 1.0
        
        lineChart?.legend.form = ChartLegend.Form.Line
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(OrangeChartViewController.setChartsTimer(_:)), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    
    func setChartsTimer(timer: NSTimer){
        mbedderGetNodeValue()
    }
    
    func setCharts(){
        var demoDataEntries: [ChartDataEntry] = []
        for i in 0..<time.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            demoDataEntries.append(dataEntry)
        }
        if lineChart.data?.dataSetCount > 0 {
            lineChart.data?.removeDataSetByIndex(0)
        }
        let lineChartDataSet = LineChartDataSet(yVals: demoDataEntries, label: "value")
        lineChartDataSet.highlightLineDashLengths = [5.0, 2.5]
        lineChartDataSet.setColor(UIColor.blackColor())
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 3.0
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.valueFont = UIFont.systemFontOfSize(9.0)
        lineChartDataSet.lineDashLengths = [5.0, 5.0]
        lineChartDataSet.lineWidth = 1.0
        let lineChartData = LineChartData(xVals: time, dataSet: lineChartDataSet)
        lineChart.data = lineChartData
    }
    //MARK: random number
    func changeData(string: String){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.NSMinuteCalendarUnit, .NSSecondCalendarUnit], fromDate: date)
        let currentTime = String(format: "%02d", components.minute) + ":" + String(format: "%02d", components.second)
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
        dispatch_async(dispatch_get_main_queue(), {
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
    
    func didPUTthenPOST(resource: String) {
        //not used here
    }
    
    func didUpdatedValue(string: String, resource: String) {
        //not used here
    }
    
    func mbedderGetNodeValue() {
        print("\(TAG)mbedderGetNodeValue:")
        switch self.titleName {
        case "Temperature"?:
            Mbedder.sharedInstance().getNodeValue("/3303/0/5700")
            break
        case "Humidity"?:
            Mbedder.sharedInstance().getNodeValue("/3304/0/5700")
            break
        case "Illuminance"?:
            Mbedder.sharedInstance().getNodeValue("/3301/0/5700")
            break
        case "Activity"?:
            Mbedder.sharedInstance().getNodeValue("/3302/0/5500")
            break
        default:
            break
        }
    }
    
    func returnPayload(string: String, resource: String) {
        print("\(TAG)returnPayload:")
        changeData(string)
    }
    
    func returnStatus(string: String, resource: String) {
        print("\(TAG)returnStatus: \(string)")
    }
    
    func notReadingEnd() {
        //not used here
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
