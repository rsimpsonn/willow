//
//  SignupViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/29/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
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
    
    @IBAction func signUpTapped(_ sender: Any) {
        if let email = self.emailField.text, let password = self.passwordField.text, let confirm = self.confirmField.text, let firstName = self.firstNameField.text, let lastName = self.lastNameField.text {
            if password == confirm {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    Firestore.firestore().collection("users").document((user?.uid)!).setData([
                        "exp": 0,
                        "firstName": firstName,
                        "lastName": lastName,
                        "level": 1
                        ])
                    
                    let docRef = Firestore.firestore().collection("users/\((user?.uid)!)/goals")
                        docRef.document("firstGoal").setData(["description": goals.firstGoal])
                        docRef.document("secondGoal").setData(["description": goals.secondGoal])
                        docRef.document("thirdGoal").setData(["description": goals.thirdGoal])
                        docRef.document("fourthGoal").setData(["description": goals.fourthGoal])
                    if let storyboard = self.storyboard {
                        let vc = storyboard.instantiateViewController(withIdentifier: "mainView")
                        self.present(vc, animated: false, completion: nil)
                    }
                }
                
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

}
