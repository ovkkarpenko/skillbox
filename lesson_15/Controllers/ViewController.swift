//
//  ViewController.swift
//  lesson_15
//
//  Created by Oleksandr Karpenko on 24.09.2020.
//

import UIKit
import GPUImage
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    let image = UIImage(named: "1")
    var imageView: UIImageView!
    
    var player: AVPlayer!
    var gpuMovie: GPUImageMovie!
    var filteredView: GPUImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: image)
        imageView.frame = photoView.bounds
        
        photoView.addSubview(imageView)
        filter1(UIButton())
        
        let path = Bundle.main.path(forResource: "1", ofType: "mov")!
        let url = URL(fileURLWithPath: path)
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        
        videoView.layer.addSublayer(playerLayer)
        
        gpuMovie = GPUImageMovie(playerItem: playerItem)!
        gpuMovie.playAtActualSpeed = true
        
        filteredView = GPUImageView();
        filteredView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        playerLayer.addSublayer(filteredView.layer)
    }
    
    @IBAction func filter1(_ sender: Any) {
        let f = GPUImageSepiaFilter()
        
        if videoView.isHidden {
            applyFilter { [unowned self] in
                let result = f.image(byFilteringImage: image)
                
                DispatchQueue.main.async {
                    imageView.image = result
                }
            }
        } else {
            gpuMovie.removeAllTargets()
            gpuMovie.addTarget(f)
            gpuMovie.playAtActualSpeed = true
            f.addTarget(filteredView)
            
            gpuMovie.startProcessing()
            player.play()
        }
    }
    
    @IBAction func filter2(_ sender: Any) {
        let f1 = GPUImageSepiaFilter()
        let f2 = GPUImageBoxBlurFilter()
        f2.blurRadiusInPixels = 20
        let f3 = GPUImageGammaFilter()
        f3.gamma = 2
        
        if videoView.isHidden {
            applyFilter { [unowned self] in
                let picture = GPUImagePicture(image: image)!
                
                picture.addTarget(f1)
                f1.addTarget(f2)
                f2.addTarget(f3)
                f3.useNextFrameForImageCapture()
                picture.processImage()
                
                let result = f3.imageFromCurrentFramebuffer()
                
                DispatchQueue.main.async {
                    imageView.image = result
                }
            }
        } else {
            gpuMovie.removeAllTargets()
            gpuMovie.addTarget(f1)
            f1.addTarget(f2)
            f2.addTarget(f3)
            gpuMovie.playAtActualSpeed = true
            f3.addTarget(filteredView)
            
            gpuMovie.startProcessing()
            player.play()
        }
    }
    
    @IBAction func filter3(_ sender: Any) {
        let f = GPUImagePixellateFilter()
        
        if videoView.isHidden {
            applyFilter { [unowned self] in
                let result = f.image(byFilteringImage: image)
                
                DispatchQueue.main.async {
                    imageView.image = result
                }
            }
        } else {
            gpuMovie.removeAllTargets()
            gpuMovie.addTarget(f)
            gpuMovie.playAtActualSpeed = true
            f.addTarget(filteredView)
            
            gpuMovie.startProcessing()
            player.play()
        }
    }
    
    @IBAction func filter4(_ sender: Any) {
        let f1 = GPUImagePixellateFilter()
        let f2 = GPUImagePolarPixellateFilter()
        
        if videoView.isHidden {
            applyFilter { [unowned self] in
                let picture = GPUImagePicture(image: image)!
                
                picture.addTarget(f1)
                f1.addTarget(f2)
                f2.useNextFrameForImageCapture()
                picture.processImage()
                
                let result = f2.imageFromCurrentFramebuffer()
                
                DispatchQueue.main.async {
                    imageView.image = result
                }
            }
        } else {
            gpuMovie.removeAllTargets()
            gpuMovie.addTarget(f1)
            f1.addTarget(f2)
            gpuMovie.playAtActualSpeed = true
            f2.addTarget(filteredView)
            
            gpuMovie.startProcessing()
            player.play()
        }
    }
    
    @IBAction func filter5(_ sender: Any) {
        let f = GPUImageLookupFilter()
        let lut = GPUImagePicture(image: UIImage(named: "2"))!
        
        if videoView.isHidden {
            applyFilter { [unowned self] in
                let picture = GPUImagePicture(image: image)!
                
                picture.addTarget(f, atTextureLocation: 0)
                lut.addTarget(f, atTextureLocation: 1)
                f.useNextFrameForImageCapture()
                
                lut.processImage()
                picture.processImage()
                
                let result = f.imageFromCurrentFramebuffer()
                
                DispatchQueue.main.async {
                    imageView.image = result
                }
            }
        } else {
            
        }
    }
    
    func applyFilter(_ filter: @escaping (() -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            filter()
        }
    }
    
    @IBAction func changeSourceType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showSource(.photo)
        } else if sender.selectedSegmentIndex == 1 {
            showSource(.video)
        }
    }
    
    enum SourceType {
        case photo
        case video
    }
    
    func showSource(_ type: SourceType) {
        let isPhoto = type == .photo
        
        photoView.isHidden = !isPhoto
        videoView.isHidden = isPhoto
    }
    
}

