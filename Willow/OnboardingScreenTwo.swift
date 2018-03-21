//
//  OnboardingScreenTwo.swift
//  Willow
//
//  Created by Ryan Simpson on 1/4/18.
//  Copyright © 2018 Ryan Simpson. All rights reserved.
//

import UIKit

class OnboardingScreenTwo: UIViewController {
    @IBOutlet weak var upperText: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lowerText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [], animations: {self.image.alpha = 1
            self.upperText.alpha = 1
            self.lowerText.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
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
