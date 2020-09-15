//
//  Task3DetailsViewController.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

class Task3DetailsViewController: UIViewController {

    var message = ""
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = message
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
