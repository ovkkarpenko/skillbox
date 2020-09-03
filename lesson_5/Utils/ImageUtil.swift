//
//  ImageUtil.swift
//  lesson_5
//
//  Created by Oleksandr Karpenko on 03.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    func loadFromURL(_ url: URL) {
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(data: data)
                }
            }
        }
    }
    
    func blur() {
        guard let image = self.image else { return }
        
        DispatchQueue.global(qos: .utility).async {
            let filter = CIFilter(name: "CIGaussianBlur")!
            let inputImage = CIImage(cgImage: image.cgImage!)
            
            filter.setValue(inputImage, forKey: "inputImage")
            filter.setValue(10, forKey: "inputRadius")
            
            let blurred = filter.outputImage
            
            var newImageSize: CGRect = (blurred?.extent)!
            newImageSize.origin.x += (newImageSize.size.width - image.size.width) / 2
            newImageSize.origin.y += (newImageSize.size.height - image.size.height) / 2
            newImageSize.size = image.size
            
            let resultImage: CIImage = filter.value(forKey: "outputImage") as! CIImage
            let context: CIContext = CIContext.init(options: nil)
            let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
            let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
            
            DispatchQueue.main.async { [weak self] in
                self?.image = blurredImage
            }
        }
    }
}
