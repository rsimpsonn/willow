//
//  OnboardingScreenThree.swift
//  Willow
//
//  Created by Ryan Simpson on 1/4/18.
//  Copyright © 2018 Ryan Simpson. All rights reserved.
//

import UIKit

class OnboardingScreenThree: UIViewController {
    @IBOutlet weak var tex: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [], animations: {
            self.tex.alpha = 1
        }, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
