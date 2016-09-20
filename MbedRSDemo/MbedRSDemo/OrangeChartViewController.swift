//
//  OrangeChartViewController.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/13/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import Charts

class OrangeChartViewController: UIViewController, ChartViewDelegate {
    var time = ["05:00", "05:05", "05:10", "05:15", "05:20", "05:25", "05:30", "05:35", "05:40", "05:45"]
    var values = [1.0, 2.0, 3.0, 4.0, 5.0, 6.5, 1.2, 8.1, 9.0, 10.0]
    
    var titleName: String?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet weak var lineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = titleName
        setupLineCharts(time, value: values)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCustomTitle(title: String) {
        self.titleName = title
    }
    
    internal func setupLineCharts(time: [String], value: [Double]){
        lineChart?.delegate = self
        lineChart?.descriptionText = titleName!
        lineChart?.noDataTextDescription = "No data coming in!"
        lineChart?.dragEnabled = true
        lineChart?.setScaleEnabled(true)
        lineChart?.pinchZoomEnabled = true
        lineChart?.drawGridBackgroundEnabled = true
        
        let llXAxis: ChartLimitLine = ChartLimitLine(limit: 10.0, label: "Index 10")
        llXAxis.lineWidth = 4.0
        llXAxis.lineDashLengths = [(10.0), (10.0), (0.0)]
        llXAxis.labelPosition = ChartLimitLine.LabelPosition.RightBottom
        llXAxis.valueFont = UIFont.systemFontOfSize(10.0)
        
        lineChart?.xAxis.gridLineDashLengths = [(10.0), (10.0)]
        lineChart?.xAxis.gridLineDashPhase = 0.0
        
        let leftAxis = lineChart?.leftAxis
        leftAxis?.removeAllLimitLines()
        leftAxis?.axisMaxValue = 15.0
        leftAxis?.axisMinValue = 0.0
        leftAxis?.gridLineDashLengths = [5.0, 5.0]
        leftAxis?.drawZeroLineEnabled = false
        leftAxis?.drawLimitLinesBehindDataEnabled = true
        
        lineChart?.legend.form = ChartLegend.Form.Line
        let userInfo: [String: AnyObject] = ["time": time, "value": values]
        let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(OrangeChartViewController.setChartsTimer(_:)), userInfo: userInfo, repeats: true)
        timer.fire()
    }
    
    internal func setChartsTimer(timer: NSTimer){
        setCharts(time, values: values)
    }
    
    internal func setCharts(dataPoints: [String], values: [Double]){
        var demoDataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
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
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChart.data = lineChartData
    
        changeData()
    }
    
    internal func changeData(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.NSMinuteCalendarUnit, .NSSecondCalendarUnit], fromDate: date)
        let currentTime = String(components.minute) + ":" + String(components.second)
        print("Current Time: " + currentTime)
        time.removeFirst()
        time.append(currentTime)
        values.removeFirst()
        let random = Double(arc4random_uniform(15) + 1)
        values.append(random)
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
