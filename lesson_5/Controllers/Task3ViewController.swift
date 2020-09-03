//
//  Task3ViewController.swift
//  lesson_5
//
//  Created by Oleksandr Karpenko on 03.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Foundation

class Task3ViewController: UIViewController {
    
    var simpleNumbers: [Int] = []
    
    @IBOutlet weak var numberTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func calculate(_ sender: Any) {
        guard let numberText = numberTextfield.text,
            let number = Int(numberText) else { return }
        
        var threadDuration = 0
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            threadDuration+=1
        }
        
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            for n in 1..<number {
                if self.isPrime(n) {
                    self.simpleNumbers.append(n)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                print("Duration: \(threadDuration) sec.")
                print(self?.simpleNumbers ?? "")
                
                timer.invalidate()
            }
        }
    }
    
    func isPrime(_ n: Int) -> Bool
    {
        if (n > 1)
        {
            for i in 2..<n {
                if n % i == 0 {
                    return false
                }
            }
            return true;
        }
        return false;
    }
    
}
