//
//  ViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/18/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import AudioToolbox
import FirebaseFirestore
import EFCountingLabel
import Firebase

struct globals {
    static var goalList = [String: String]()
    static var oneWeekCount = 0
    static var twoWeekCount = 0
    static var threeWeekCount = 0
    static var fourWeekCount = 0
    static var exp = 0
    static var constant = 0
    static var name = ""
    static var uid = (Auth.auth().currentUser?.uid)!
}

func convertToPoints(count: Int) -> Float {
    let totalCount = Float(globals.oneWeekCount + globals.twoWeekCount + globals.threeWeekCount + globals.fourWeekCount)
    if totalCount == 0 {
        return Float(globals.constant)
    }
    let fract = (1 - (Float(count)/totalCount))
    return round(100 * (fract * Float(globals.constant) / (1 - fract))) / 200
    
}

var db = Firestore.firestore()
let impact = UISelectionFeedbackGenerator()
let feedback = UIImpactFeedbackGenerator()
let notification = UINotificationFeedbackGenerator()

class ViewController: UIViewController {

    @IBOutlet weak var willow: UIImageView!
    @IBOutlet weak var shadow: UIImageView!
    @IBOutlet weak var outfit: UIImageView!
    
    @IBOutlet weak var willowArea: UIButton!
    
    @IBOutlet weak var goalOneButton: UIButton!
    @IBOutlet weak var goalTwoButton: UIButton!
    @IBOutlet weak var goalThreeButton: UIButton!
    @IBOutlet weak var goalFourButton: UIButton!
    
    @IBOutlet weak var goalOneProgress: UIProgressView!
    @IBOutlet weak var goalTwoProgress: UIProgressView!
    @IBOutlet weak var goalThreeProgress: UIProgressView!
    @IBOutlet weak var goalFourProgress: UIProgressView!
    
    @IBOutlet weak var thresholdTicker: EFCountingLabel!
    @IBOutlet weak var expTicker: EFCountingLabel!
    @IBOutlet weak var levelTicker: UILabel!
    
    var exp = 0
    var level = 0
    var threshold = 0
    var constant = 0
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            globals.uid = (user?.uid)!
            db.collection("users").document((user?.uid)!).getDocument { (document, error) in
                if let document = document {
                    globals.name = String(describing: document.data()["firstName"]!) + " " + String(describing: document.data()["lastName"]!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("users/" + globals.uid + "/goals")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        globals.goalList[document.documentID] = String(describing: document.data()["description"]!)
                    }
                    self.goalOneButton.setTitle(globals.goalList["firstGoal"], for: .normal)
                    self.goalTwoButton.setTitle(globals.goalList["secondGoal"], for: .normal)
                    self.goalThreeButton.setTitle(globals.goalList["thirdGoal"], for: .normal)
                    self.goalFourButton.setTitle(globals.goalList["fourthGoal"], for: .normal)
                }
        }
        
        db.collection("users").document("\(globals.uid)").getDocument { (document, error) in
            if let document = document {
                self.exp = document.data()["exp"] as! Int
                globals.exp = self.exp
                self.level = document.data()["level"] as! Int
                self.levelTicker.text = self.toRoman(number: self.level)
                if self.level != 1 {
                    self.outfit.image = UIImage(named: "lvl\(self.level).png")
                    self.grow(level: self.level)
                }
                db.collection("willow").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if (document.documentID == "constants") {
                                self.constant = document.data()[String(describing: self.level)] as! Int
                                globals.constant = self.constant
                            } else {
                                self.threshold = document.data()[String(describing: self.level)] as! Int
                                self.thresholdTicker.method = .easeOut
                                self.thresholdTicker.animationDuration = 1.0
                                self.thresholdTicker.format = "%d"
                                self.thresholdTicker.countFromZeroTo(CGFloat(self.threshold))
                                self.expTicker.method = .easeOut
                                self.expTicker.animationDuration = 2.0
                                self.expTicker.format = "%d"
                                self.expTicker.countFromZeroTo(CGFloat(self.exp))
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        
        
        self.weeklyCounts(completion: self.setAllProgresses)
        
        }
    
    override func viewDidAppear(_ animated: Bool) {
    

        UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .autoreverse], animations: { self.willow.center.y -=  20
            self.outfit.center.y -= 20
        }, completion: nil)
        UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .autoreverse], animations: { self.shadow.transform =  CGAffineTransform(scaleX: 2, y: 1.2)}, completion: nil)
        var blinkTimer: Timer!
        blinkTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(blink), userInfo: nil, repeats: true)
        blinkTimer.fire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProgress(goal: Int) -> Float {
        var totalWeekCount = globals.oneWeekCount + globals.twoWeekCount + globals.threeWeekCount + globals.fourWeekCount
        if totalWeekCount == 0 {
            return 0
        }
        print(goal, totalWeekCount)
        return Float(goal)/Float(totalWeekCount)
    }
    
    func setAllProgresses() {
        self.goalOneProgress.setProgress(getProgress(goal: globals.oneWeekCount), animated: true)
        self.goalTwoProgress.setProgress(getProgress(goal: globals.twoWeekCount), animated: true)
        self.goalThreeProgress.setProgress(getProgress(goal: globals.threeWeekCount), animated: true)
        self.goalFourProgress.setProgress(getProgress(goal: globals.fourWeekCount), animated: true)
    }
    
    func weeklyCounts(completion: @escaping () -> ()) {
        let userCalendar = Calendar.current
        let rnDate = Date()
        var count = 0
        
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
                    if rnDate - 604800 <=  userCalendar.date(from: date)! {
                        count += 1
                    }
                }
                globals.oneWeekCount = count
            }
            count = 0
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
                    if rnDate - 604800 <=  userCalendar.date(from: date)! {
                        count += 1
                    }
                }
                globals.twoWeekCount = count
            }
            count = 0
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
                    if rnDate - 604800 <=  userCalendar.date(from: date)! {
                        count += 1
                    }
                }
                globals.threeWeekCount = count
            }
            count = 0
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
                    if rnDate - 604800 <=  userCalendar.date(from: date)! {
                        count += 1
                    }
                }
                globals.fourWeekCount = count
            }
            completion()
        }
    }
    
    func toRoman(number: Int) -> String {
        var copy = number
        var romans = ["M":1000,"CM":900,"D":500,"CD":400,"C":100,"XC":90,"L":50,"XL":40,"X":10,"IX":9,"V":5,"IV":4,"I":1]
        var romanValue = ""
        for (key, value) in romans {
            while copy >= value {
                romanValue += key
                copy -= value
            }
        }
        return romanValue
    }

    
    @objc func blink() {
        var imagesNames = ["blink_1", "blink_2", "blink_3", "blink_4", "blink_5", "blink_6", "blink_7", "blink_8", "blink_9","blink_9", "blink_9", "blink_8", "blink_7", "blink_6", "blink_5", "blink_4", "blink_3", "blink_2", "blink_1"]
        
        var images = [UIImage]()
        
        for i in 0..<imagesNames.count {
            
            images.append(UIImage(named: imagesNames[i])!)
        }
        
        self.willow.animationImages = images
        self.willow.animationDuration = 0.5
        self.willow.animationRepeatCount = 1
        self.willow.startAnimating()
    }
    
    @objc func grow(level: Int) {
        var imagesNames = ["lvl\(level)grow_1", "lvl\(level)grow_2", "lvl\(level)grow_3", "lvl\(level)grow_4", "lvl\(level)grow_5", "lvl\(level)grow_6", "lvl\(level)grow_7", "lvl\(level)grow_8", "lvl\(level)grow_9"]
        
        var images = [UIImage]()
     
        for i in 0..<imagesNames.count {
            images.append(UIImage(named: imagesNames[i])!)
        }
        
        self.outfit.animationImages = images
        self.outfit.animationDuration = 0.5
        self.outfit.animationRepeatCount = 1
        self.outfit.startAnimating()
    }
    
    @IBAction func toggleProfile(_ sender: Any) {
        feedback.impactOccurred()
    }
    
    @IBAction func toggleStats(_ sender: Any) {
        feedback.impactOccurred()
        performSegue(withIdentifier: "homeToStats", sender: self)
    }
    
    @IBAction func changeCount(sender: AnyObject) {
    guard let button = sender as? UIButton else {
    return 
    }
        impact.selectionChanged()
       
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {button.alpha = 0.5
        button.alpha = 1}, completion: nil)
        let now = Date()
        let formatter = DateFormatter()
        var calendar = Calendar.current
        calendar.timeZone = .current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        let day = calendar.component(.day, from: now)
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        var fract: Float = 0
    
    switch button.tag {
    case 1:
        let goalRef = db.collection("users/\(globals.uid)/goals/firstGoal/history")
        goalRef.addDocument(data: ["day": day, "month": month, "year": year, "hour": hour, "minutes": minutes])
        globals.oneWeekCount += 1
        self.exp = self.exp + Int(convertToPoints(count: globals.oneWeekCount))
    case 2:
       let goalRef = db.collection("users/\(globals.uid)/goals/secondGoal/history")
       goalRef.addDocument(data: ["day": day, "month": month, "year": year, "hour": hour, "minutes": minutes])
        globals.twoWeekCount += 1
       self.exp = self.exp + Int(convertToPoints(count: globals.twoWeekCount))
    case 3:
        let goalRef = db.collection("users/\(globals.uid)/goals/thirdGoal/history")
        goalRef.addDocument(data: ["day": day, "month": month, "year": year, "hour": hour, "minutes": minutes])
        globals.threeWeekCount += 1
        self.exp = self.exp + Int(convertToPoints(count: globals.threeWeekCount))
    case 4:
        let goalRef = db.collection("users/\(globals.uid)/goals/fourthGoal/history")
        goalRef.addDocument(data: ["day": day, "month": month, "year": year, "hour": hour, "minutes": minutes])
        globals.fourWeekCount += 1
        self.exp = self.exp + Int(convertToPoints(count: globals.fourWeekCount))
    default:
    print("Oops")
    }
        if self.exp >= self.threshold {
            self.level += 1
            self.levelTicker.text = self.toRoman(number: self.level)
            self.outfit.image = UIImage(named: "lvl\(self.level).png")
            self.grow(level: self.level)
            self.exp = self.exp % self.threshold
            db.collection("users").document("\(globals.uid)").updateData([
                "level": self.level,
                "exp": self.exp
                ])
            db.collection("willow").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if (document.documentID == "constants") {
                            self.constant = document.data()[String(describing: self.level)] as! Int
                        } else {
                            self.threshold = document.data()[String(describing: self.level)] as! Int
                            self.thresholdTicker.countFromCurrentValueTo(CGFloat(self.threshold))
                            self.expTicker.countFromCurrentValueTo(CGFloat(self.exp))
                    }
                }
            }
            }
        } else {
            self.exp = (self.exp + Int(fract * Float(self.constant)))
            self.expTicker.countFromCurrentValueTo(CGFloat(self.exp))
            db.collection("users").document("\(globals.uid)").updateData([
                "exp": self.exp
                ])
        }
        setAllProgresses()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.handle!)
    }
}




