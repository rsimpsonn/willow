//
//  OnboardingScreenFive.swift
//  Willow
//
//  Created by Ryan Simpson on 1/4/18.
//  Copyright © 2018 Ryan Simpson. All rights reserved.
//

import UIKit

class OnboardingScreenFive: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var allDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.5, delay: 1, options: [], animations: {self.image.alpha = 1
            self.text.alpha = 1
            self.allDone.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            self.image.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
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
