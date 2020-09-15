//
//  Task4ViewController.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

class Task4ViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func selectPhotoButtonClick(_ sender: Any) {
        self.picker.swizzling(vc: self, callback: { [weak self] output in
            guard let self = self else { return }
            // output - вывод originalImage в результате свизлинга
            DispatchQueue.main.async {
                self.image.image = output
            }
        })
    }
    
}
