//
//  ViewController.swift
//  lesson_6
//
//  Created by Oleksandr Karpenko on 03.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var number: Int?
    
    @IBOutlet weak var label: UILabel!
    
    deinit {
        print("ViewController---")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController+++")
    }
    
}

