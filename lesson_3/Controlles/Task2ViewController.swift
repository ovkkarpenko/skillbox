//
//  Task2ViewController.swift
//  lesson_3
//
//  Created by Oleksandr Karpenko on 31.08.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Bond

class Task2ViewController: UIViewController {
    
    @IBOutlet weak var queryTextfield: UITextField!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryTextfield.reactive.text
            .observeNext(with: { text in
                if let timer = self.timer {
                    timer.invalidate()
                }
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    if let text = text {
                        print("Sending a request for '\(text)'")
                    }
                })
            }).dispose(in: reactive.bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
}
