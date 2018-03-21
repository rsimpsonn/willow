//
//  StatsViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/21/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import Charts
import FirebaseFirestore

protocol GetChartData {
    func getChartData(with dataPoints: [String], values: [String])
    var workoutDuration: [String] {get set}
    var beatsPerMinute: [String] {get set}
}

class StatsViewController: UIViewController, GetChartData {

    
    @IBOutlet weak var goalOneWeekCount: UILabel!
    @IBOutlet weak var goalTwoWeekCount: UILabel!
    @IBOutlet weak var goalThreeWeekCount: UILabel!
    @IBOutlet weak var goalFourWeekCount: UILabel!
    
    @IBOutlet weak var goalOneValue: UILabel!
    @IBOutlet weak var goalTwoValue: UILabel!
    @IBOutlet weak var goalThreeValue: UILabel!
    @IBOutlet weak var goalFourValue: UILabel!
    
    @IBOutlet weak var goalOneText: UILabel!
    @IBOutlet weak var goalTwoText: UILabel!
    @IBOutlet weak var goalThreeText: UILabel!
    @IBOutlet weak var goalFourText: UILabel!
    
    var goalOneHistory = [Date]()
    var goalTwoHistory = [Date]()
    var goalThreeHistory = [Date]()
    var goalFourHistory = [Date]()
    
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    override func viewDidLoad() {
        let userCalendar = Calendar.current
        let rnDate = Date()
        let totalCount = Float(globals.oneWeekCount + globals.twoWeekCount + globals.threeWeekCount + globals.fourWeekCount)
        
        self.goalOneWeekCount.text = String(describing: globals.oneWeekCount)
        self.goalTwoWeekCount.text = String(describing: globals.twoWeekCount)
        self.goalThreeWeekCount.text = String(describing: globals.threeWeekCount)
        self.goalFourWeekCount.text = String(describing: globals.fourWeekCount)
        
        self.goalOneValue.text = String(describing: convertToPoints(count: globals.oneWeekCount))
        self.goalTwoValue.text = String(describing: convertToPoints(count: globals.twoWeekCount))
        self.goalThreeValue.text = String(describing: convertToPoints(count: globals.threeWeekCount))
        self.goalFourValue.text = String(describing: convertToPoints(count: globals.fourWeekCount))
        
        self.goalOneText.text = globals.goalList["firstGoal"]
        self.goalTwoText.text = globals.goalList["secondGoal"]
        self.goalThreeText.text = globals.goalList["thirdGoal"]
        self.goalFourText.text = globals.goalList["fourthGoal"]
        
        db.collection("users/\(globals.uid)/goals/firstGoal/history").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("Document: \(document.data())")
                    let docData = document.data()
                    let date = DateComponents(year: Int(String(describing: docData["year"]!)),
                                              month: Int(String(describing: docData["month"]!)),
                                              day: Int(String(describing: docData["day"]!)), hour: Int(String(describing: docData["hour"]!)))
                    self.goalOneHistory.append(userCalendar.date(from: date)!)
                }
            }
        }
        
        db.collection("users/\(globals.uid)/goals/secondGoal/history").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    var date = DateComponents()
                    date.year = Int(String(describing: docData["year"]!))
                    date.month = Int(String(describing: docData["month"]!))
                    date.hour = Int(String(describing: docData["hour"]!))
                    date.day = Int(String(describing: docData["day"]!))
                    self.goalTwoHistory.append(userCalendar.date(from: date)!)
                }
            }
        }
        
        db.collection("users/\(globals.uid)/goals/thirdGoal/history").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    var date = DateComponents()
                    date.year = Int(String(describing: docData["year"]!))
                    date.month = Int(String(describing: docData["month"]!))
                    date.hour = Int(String(describing: docData["hour"]!))
                    date.day = Int(String(describing: docData["day"]!))
                    self.goalThreeHistory.append(userCalendar.date(from: date)!)
                }
            }
            self.populateChartData()
            self.cubicChart()
        }
        
        db.collection("users/\(globals.uid)/goals/fourthGoal/history").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("Document: \(document.data())")
                    let docData = document.data()
                    var date = DateComponents()
                    date.year = Int(String(describing: docData["year"]!))
                    date.month = Int(String(describing: docData["month"]!))
                    date.hour = Int(String(describing: docData["hour"]!))
                    date.day = Int(String(describing: docData["day"]!))
                    self.goalFourHistory.append(userCalendar.date(from: date)!)
                }
            }
        }
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleProfile(_ sender: Any) {
        performSegue(withIdentifier: "statsToProfile", sender: self)
    }
    
    func populateChartData() {
        var allActions = self.goalOneHistory + self.goalTwoHistory + self.goalThreeHistory + self.goalFourHistory
        allActions.sort { (a, b) -> Bool in
            a < b
        }
        print(allActions)
        while allActions.count > 0 {
            if workoutDuration.index(of: String(describing: Calendar.current.component(.month, from: allActions[0])) + "/" + String(describing: Calendar.current.component(.day, from: allActions[0]))) == nil {
                workoutDuration.append(String(describing: Calendar.current.component(.month, from: allActions[0])) + "/" + String(describing: Calendar.current.component(.day, from: allActions[0])))
                beatsPerMinute.append(String(describing: allActions.filter{ Calendar.current.isDate(allActions[0], inSameDayAs: $0) }.count))
            }
            allActions.remove(at: 0)
        }
        print(workoutDuration)
        print(beatsPerMinute)
        self.getChartData(with: workoutDuration, values: beatsPerMinute)
    }
    
    func cubicChart() {
        let cubicChart = CubicChart(frame: CGRect(x: self.view.frame.width * 0.025, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.3))
        cubicChart.delegate = self
        self.view.addSubview(cubicChart)
    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.workoutDuration = dataPoints
        self.beatsPerMinute = values
    }
}

public class ChartFormatter: NSObject, IAxisValueFormatter {
    var workoutDuration = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return workoutDuration[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.workoutDuration = values
    }
}
