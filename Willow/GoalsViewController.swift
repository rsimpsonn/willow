//
//  GoalsViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/30/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

struct goals {
    static var firstGoal = ""
    static var secondGoal = ""
    static var thirdGoal = ""
    static var fourthGoal = ""
}

class GoalsViewController: UIViewController {
    
    @IBOutlet weak var goalOneField: UITextField!
    @IBOutlet weak var goalTwoField: UITextField!
    @IBOutlet weak var goalThreeField: UITextField!
    @IBOutlet weak var goalFourField: UITextField!
    
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStarted(_ sender: Any) {
        goals.firstGoal = self.goalOneField.text!
        goals.secondGoal = self.goalTwoField.text!
        goals.thirdGoal = self.goalThreeField.text!
        goals.fourthGoal = self.goalFourField.text!
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
