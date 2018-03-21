//
//  CubicChart.swift
//  Willow
//
//  Created by Ryan Simpson on 12/21/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import Charts

class CubicChart: UIView {
    
    let lineChartView = LineChartView()
    var lineDataEntry: [ChartDataEntry] = []
    
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    var delegate: GetChartData! {
        didSet {
            populateData()
            cublicLineChartSetup()
        }
    }
    
    func populateData() {
        workoutDuration = delegate.workoutDuration
        beatsPerMinute = delegate.beatsPerMinute
    }
    
    func lineChartSetup() {
        self.backgroundColor = UIColor.clear
        self.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        setCublicLineChart(dataPoints: workoutDuration, values: beatsPerMinute)
        
    }
    
    func cublicLineChartSetup() {
        self.backgroundColor = UIColor.clear
        self.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //  lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.1, easingOption: .linear)
        
        setCublicLineChart(dataPoints: workoutDuration, values: beatsPerMinute)
    }
    
    func setCublicLineChart(dataPoints: [String], values: [String]) {
        lineChartView.noDataTextColor = UIColor.clear
        lineChartView.noDataText = "You haven't done anything yet!"
        lineChartView.backgroundColor = UIColor.clear
        
        for i in 0..<dataPoints.count {
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(values[i])!)
            lineDataEntry.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(values: lineDataEntry, label: "BPM")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartDataSet.colors = [UIColor.white]
        chartDataSet.setCircleColor(UIColor.white)
        chartDataSet.circleHoleColor = UIColor.white
        chartDataSet.circleRadius = 50.0
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawValuesEnabled = false
        chartDataSet.lineWidth = 2.5
        
        chartDataSet.valueFont = UIFont(name: "Avenir", size: 12.0)!
        
        let gradientColors = [ UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.0).cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.8, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()
        xaxis.valueFormatter = formatter
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelCount = 5
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        lineChartView.chartDescription?.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.enabled = true
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.leftAxis.axisLineColor = UIColor.clear
        lineChartView.leftAxis.labelCount = 4
        lineChartView.leftAxis.granularityEnabled = true
        lineChartView.leftAxis.granularity = 1.0
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.xAxis.axisLineColor = UIColor.white
        lineChartView.borderLineWidth = 1
        lineChartView.drawMarkers = false
        lineChartView.drawBordersEnabled = false
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.data = chartData
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
