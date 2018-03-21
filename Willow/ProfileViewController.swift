//
//  ProfileViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/18/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var goalOneLabel: UILabel!
    @IBOutlet weak var goalTwoLabel: UILabel!
    @IBOutlet weak var goalThreeLabel: UILabel!
    @IBOutlet weak var goalFourLabel: UILabel!
    
    
    @IBOutlet weak var goalOneBox: UITextField!
    @IBOutlet weak var goalTwoBox: UITextField!
    @IBOutlet weak var goalThreeBox: UITextField!
    @IBOutlet weak var goalFourBox: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goalOneLabel.text = globals.goalList["firstGoal"]
        self.goalOneBox.text = globals.goalList["firstGoal"]
        self.goalOneBox.placeholder = globals.goalList["firstGoal"]
        self.goalTwoBox.text = globals.goalList["secondGoal"]
        self.goalTwoBox.placeholder = globals.goalList["secondGoal"]
        self.goalTwoLabel.text = globals.goalList["secondGoal"]
        self.goalThreeLabel.text = globals.goalList["thirdGoal"]
        self.goalThreeBox.text = globals.goalList["thirdGoal"]
        self.goalThreeBox.placeholder = globals.goalList["thirdGoal"]
        self.goalFourLabel.text = globals.goalList["fourthGoal"]
        self.goalFourBox.text = globals.goalList["fourthGoal"]
        self.goalFourBox.placeholder = globals.goalList["fourthGoal"]
        self.nameLabel.text = globals.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func toggleHome(_ sender: Any) {
        performSegue(withIdentifier: "profileToHome", sender: self)
    }
    
    @IBAction func editGoals(_ sender: Any) {
        self.goalOneLabel.isHidden = true
        self.goalTwoLabel.isHidden = true
        self.goalThreeLabel.isHidden = true
        self.goalFourLabel.isHidden = true
        
        UIView.animate(withDuration: 0.9, delay: 0, animations: { self.goalOneBox.alpha = 1
            self.goalTwoBox.alpha = 1
            self.goalThreeBox.alpha = 1
            self.goalFourBox.alpha = 1
        }, completion: nil)
        
        self.goalOneBox.isHidden = false
        self.goalTwoBox.isHidden = false
        self.goalThreeBox.isHidden = false
        self.goalFourBox.isHidden = false
        
        self.editButton.isHidden = true
        self.doneButton.isHidden = false
        
    }
    
    @IBAction func pressDone(_ sender: Any) {
        UIView.animate(withDuration: 0.9, delay: 0, animations: { self.goalOneBox.alpha = 0
            self.goalTwoBox.alpha = 0
            self.goalThreeBox.alpha = 0
            self.goalFourBox.alpha = 0
        }, completion: nil)
        
        self.goalOneLabel.isHidden = false
        self.goalOneLabel.text = self.goalOneBox.text
        self.goalTwoLabel.isHidden = false
        self.goalTwoLabel.text = self.goalTwoBox.text
        self.goalThreeLabel.isHidden = false
        self.goalThreeLabel.text = self.goalThreeBox.text
        self.goalFourLabel.isHidden = false
        self.goalFourLabel.text = self.goalFourBox.text
        
        self.editButton.isHidden = false
        self.doneButton.isHidden = true
        if goalOneBox.text != globals.goalList["firstGoal"] {
            db.document("users/\(globals.uid)/goals/firstGoal").updateData(["description": self.goalOneBox.text as Any])
        }
        if (goalTwoBox.text != globals.goalList["secondGoal"]) {
            db.document("users/\(globals.uid)/goals/secondGoal").updateData(["description": self.goalTwoBox.text as Any])
        }
        if (goalThreeBox.text != globals.goalList["thirdGoal"]) {
            db.document("users/\(globals.uid)/goals/thirdGoal").updateData(["description": self.goalThreeBox.text as Any])
        }
        if (goalFourBox.text != globals.goalList["fourthGoal"]) {
            db.document("users/\(globals.uid)/goals/fourthGoal").updateData(["description": self.goalFourBox.text as Any])
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "loginView")
            self.present(vc, animated: false, completion: nil)
        }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


