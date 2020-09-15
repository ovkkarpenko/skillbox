//
//  Task4ViewController.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

class Task4ViewController: UIViewController {
    
    let imagePicker = ImagePicker()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func selectPhotoButtonClick(_ sender: Any) {
        imagePicker.selectPhoto(from: self) { image in
            DispatchQueue.main.async { [weak self] in
                self?.image.image = image
            }
            
        }
    }
    
}
