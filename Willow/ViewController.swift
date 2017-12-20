//
//  ViewController.swift
//  Willow
//
//  Created by Ryan Simpson on 12/18/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit

var featCount = 0

class ViewController: UIViewController {

    @IBOutlet weak var willow: UIImageView!
    @IBOutlet weak var shadow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.9, delay: 0, options: [.repeat, .autoreverse], animations: { self.willow.center.y -=  15}, completion: nil)
        UIView.animate(withDuration: 0.9, delay: 0, options: [.repeat, .autoreverse], animations: { self.shadow.transform =  CGAffineTransform(scaleX: 2, y: 1.2)}, completion: nil)
        var blinkTimer: Timer!
        blinkTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(blink), userInfo: nil, repeats: true)
        blinkTimer.fire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func blink() {
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
    
    
    @IBAction func toggleProfile(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func changeCount(sender: AnyObject) {
    guard let button = sender as? UIButton else {
    return
    }
        
        UIView.animate(withDuration: 0.05, delay: 0, options: [], animations: {button.alpha = 0.5
        button.alpha = 1}, completion: nil)
    
    switch button.tag {
    case 1:
        featCount += 2
        blink()
    case 2:
        featCount += 8
    case 3:
        featCount += 10
    case 4:
        featCount += 100
    default:
    print("Unknown language")
    }
    }



}

