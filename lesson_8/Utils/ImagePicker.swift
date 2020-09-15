//
//  MyImagePicker.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import Foundation

class ImagePicker: NSObject {
    var picker = UIImagePickerController()
    var pickImageCallback : ((UIImage) -> ())?
    
    public func selectPhoto(from viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        pickImageCallback = callback
        
        viewController.present(picker, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        pickImageCallback?(image)
    }
    
}
