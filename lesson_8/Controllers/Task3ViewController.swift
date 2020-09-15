//
//  Task3ViewController.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

class Task3ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showDetails(_ sender: Any) {
        performSegueWithIdentifier(identifier: "ShowDetailsSegue", sender: nil) { (segue) in
            let vc = segue.destination as! Task3DetailsViewController
            vc.message = "Hello world"
        }
    }
    
}
