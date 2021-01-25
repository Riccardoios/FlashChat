//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // always good practise to implement this: call super after this kind of methods
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = K.appName
        
        for char in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (time) in
                self.titleLabel.text?.append(char) // time schedlued it schedule that in the next time interval it triger waht you want.. if you don't add an increasing value it's not gonna schedule an action at the text interval
            }
            charIndex += 1
        }
    }
    
    
}
