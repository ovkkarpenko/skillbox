//
//  Task5ViewController.swift
//  lesson_3
//
//  Created by Oleksandr Karpenko on 31.08.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Bond

class Task5ViewController: UIViewController {
    
    var firstFlag = false
    var secondFlag = false
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = firstButton.reactive.controlEvents(.touchUpInside)
            .observeNext { [weak self] in
                self?.firstFlag = true
                self?.isTwoButtonsPressed()
        }
        
        _ = secondButton.reactive.controlEvents(.touchUpInside)
            .observeNext { [weak self] in
                self?.secondFlag = true
                self?.isTwoButtonsPressed()
        }
    }
    
    func isTwoButtonsPressed() {
        if firstFlag && secondFlag {
            messageLabel.text = "Rocket launched"
        }
    }
    
}
