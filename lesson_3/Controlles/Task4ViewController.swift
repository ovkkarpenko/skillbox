//
//  Task4ViewController.swift
//  lesson_3
//
//  Created by Oleksandr Karpenko on 31.08.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Bond

class Task4ViewController: UIViewController {
    
    var counter = 0
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var countButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countButton.reactive.tap
            .map { self.counter+=1; return "Counter: \(self.counter)" }
            .bind(to: counterLabel.reactive.text)
            .dispose(in: reactive.bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
}
