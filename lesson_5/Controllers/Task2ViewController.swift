//
//  Task2ViewController.swift
//  lesson_5
//
//  Created by Oleksandr Karpenko on 03.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

class Task2ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://blackstarshop.ru/image/catalog/im2017/1.png")!
        image.loadFromURL(url)
    }

    @IBAction func blur(_ sender: Any) {
        image.blur()
    }
    
}
