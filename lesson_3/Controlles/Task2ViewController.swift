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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryTextfield.reactive.text
            .throttle(for: 0.5)
            .observeNext(with: { text in
                if let text = text {
                    print("Sending a request for '\(text)'")
                }
            }).dispose(in: reactive.bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
}
