//
//  SecondViewController.swift
//  lesson_6
//
//  Created by Oleksandr Karpenko on 03.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

protocol SomeDelegate: class {
    func setFiled(_ number: Int)
}

class SomeClass {
    //var delegate: SomeDelegate? --> leak memory
    weak var delegate: SomeDelegate?
    
    var action: (() -> Void)?
}

class SecondViewController: UIViewController {
    
    var someClass = SomeClass()
    
    deinit {
        print("SecondViewController---")
    }
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SecondViewController+++")
        
        someClass.delegate = self
        
        //memory leak
        //someClass.action = {
        //    self.counter += 1
        //}
        someClass.action = { [weak self] in
            self?.counter += 1
        }
    }
    
    @IBAction func action(_ sender: Any) {
        someClass.action?()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SecondViewController: SomeDelegate {
    func setFiled(_ number: Int) {
        
    }
}
