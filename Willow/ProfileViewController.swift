//
//  ProfileViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/18/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleHome(_ sender: Any) {
        performSegue(withIdentifier: "profileToHome", sender: self)
    }
    
    @IBAction func editGoals(_ sender: Any) {
        self.goalOneLabel.isHidden = true
        self.goalTwoLabel.isHidden = true
        self.goalThreeLabel.isHidden = true
        self.goalFourLabel.isHidden = true
        
        self.goalOneBox.isHidden = false
        self.goalTwoBox.isHidden = false
        self.goalThreeBox.isHidden = false
        self.goalFourBox.isHidden = false
        
        self.editButton.isHidden = true
        self.doneButton.isHidden = false
        
    }
    
    @IBAction func pressDone(_ sender: Any) {
        self.goalOneLabel.isHidden = false
        self.goalOneLabel.text = self.goalOneBox.text
        self.goalTwoLabel.isHidden = false
        self.goalTwoLabel.text = self.goalTwoBox.text
        self.goalThreeLabel.isHidden = false
        self.goalThreeLabel.text = self.goalThreeBox.text
        self.goalFourLabel.isHidden = false
        self.goalFourLabel.text = self.goalFourBox.text
        
        self.goalOneBox.isHidden = true
        self.goalTwoBox.isHidden = true
        self.goalThreeBox.isHidden = true
        self.goalFourBox.isHidden = true
        
        self.editButton.isHidden = false
        self.doneButton.isHidden = true
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
