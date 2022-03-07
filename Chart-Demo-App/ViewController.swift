//
//  ViewController.swift
//  Chart-Demo-App
//
//  Created by vignesh kumar c on 03/03/22.
//

import UIKit
import Charts
import TinyConstraints
import DropDown

class ViewController: UIViewController,ChartViewDelegate {
    
    var months: [String]!
    var amount = [Double]()
    var assets = [Double]()
    var liabilitys = [Double]()
    
    let dropDown = DropDown()
    weak var axisFormaterDelegate: IAxisValueFormatter?
    @IBOutlet weak var piechartView: PieChartView!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormaterDelegate = self
        barChartView.delegate = self
        piechartView.delegate = self
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        amount = [270.0,670.0,44.0,470.0,820.0,370.0,630.0,450.0,810.0,470.0,200.0,410.0]
        
        assets = [1,2]
        liabilitys = [15.0,35.0]
        setChart(dataEntryX: months, dataEntryY: amount)
     
        createPieChart(asset: assets, liability: liabilitys)
       
    }
    

    
    @IBAction func selectYearBtn(_ sender: Any) {
        
        dropDown.dataSource = ["2022","2021","2020","2019"]
        dropDown.anchorView = sender as! AnchorView
        dropDown.show()
        dropDown.selectionAction = { [weak self](index: Int, item: String) in guard let _ = self else{return}
            (sender as AnyObject).setTitle(item, for: .normal)
        }
        
    }
    func setChart(dataEntryX forX: [String], dataEntryY forY: [Double]){
        
        let xAxis = barChartView.xAxis
        let rightAxis = barChartView.rightAxis
        let legend = barChartView.legend
        self.barChartView.legend.enabled = false
    
        barChartView.noDataText = "You Need to provide a data for chart."
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<forX.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]), data: months as AnyObject?)
            print(dataEntry)
            dataEntries.append(dataEntry)
    }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = [NSUIColor(cgColor: CGColor(red: 22.0/255.0, green: 60.0/255.0, blue: 128.0/255.0, alpha: 1))]
        chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSet: chartDataSet)
       
        barChartView.data = chartData
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelCount = 12
        barChartView.leftAxis.labelCount = 12
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 1300
        barChartView.leftAxis.granularityEnabled = true
        barChartView.leftAxis.drawAxisLineEnabled = false
        let interval = barChartView.leftAxis.granularity
        barChartView.leftAxis.granularity = 200
        barChartView.leftAxis.spaceMax = 1
        barChartView.xAxis.drawGridLinesEnabled = false
    
//        let pFormater = NumberFormatter()
        
        
//        barChartView.barData?.barWidth = 20
        let barWidth = 0.6
        let barSpace = 20.0
        let groupSpace = 1.0

            chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
            chartData.barWidth = barWidth
       
        
        //        let maxY = 1400
//        let minY = 0
//        let ttlRange = maxY - minY
//        let interval = 200
//        barChartView.leftAxis.setLabelCount(Int(ttlRange/interval) + 1, force: true)
    
//        barChartView.leftAxis.valueFormatter = axisFormaterDelegate
        let xAxisValue = barChartView.xAxis
        xAxisValue.valueFormatter = axisFormaterDelegate
}
    func createPieChart(asset forX: [Double], liability forY: [Double]){
        
        
        var pieChartEntries: [ChartDataEntry] = []
        for i in 0..<forX.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]), data: months as AnyObject?)
            print(dataEntry)
            pieChartEntries.append(dataEntry)
    }
        let set = PieChartDataSet(entries: pieChartEntries)
        set.colors = [NSUIColor(cgColor: UIColor.link.cgColor),NSUIColor(cgColor: UIColor.red.cgColor)]
        
        let data = PieChartData(dataSet: set)
        self.piechartView.legend.enabled = false
        piechartView.rotationEnabled = false
        let pFormater = NumberFormatter()
        pFormater.numberStyle = .percent

        pFormater.maximumFractionDigits = 1
        pFormater.multiplier = 1
        pFormater.percentSymbol = "%"
        set.sliceSpace = 6
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormater))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        piechartView.holeRadiusPercent = 0.7
        piechartView.chartDescription?.enabled = true
        piechartView.data = data
        piechartView.sizeToFit()
        piechartView.highlightValues(nil)
        piechartView.maxAngle = 180
        piechartView.rotationAngle = 180
        piechartView.centerTextOffset = CGPoint(x: 0, y: -20)
        piechartView.legend.enabled = true
        let l = piechartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
    }

}
extension ViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
    
    
}
