//
//  UserViewController.swift
//  lesson_11
//
//  Created by Oleksandr Karpenko on 18.09.2020.
//

import UIKit

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOut(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
