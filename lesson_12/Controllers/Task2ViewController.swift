//
//  Task2ViewController.swift
//  lesson_12
//
//  Created by Oleksandr Karpenko on 21.09.2020.
//

import UIKit
import AVFoundation
import Vision

struct Rocket {
    var faceLayer: CAShapeLayer
    var rocket: UIImageView?
    var boom: UIImageView?
}

class Task2ViewController: UIViewController {
    
    var pathLayer: CALayer!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var rockets: [Rocket] = []
    
    lazy var faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleDetectedFaces)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCamera()
        configDrawingLayer()
    }
    
    @IBAction func fire(_ sender: Any) {
        for i in 0..<rockets.count {
            animateRocket(&rockets[i])
        }
    }
    
    func configCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else { return}
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
    }
    
    func configDrawingLayer() {
        let drawingLayer = CALayer()
        drawingLayer.backgroundColor = UIColor.black.cgColor
        drawingLayer.bounds = CGRect(x: 0, y: 0, width: previewLayer.frame.width, height: previewLayer.frame.height)
        drawingLayer.anchorPoint = CGPoint.zero
        drawingLayer.position = CGPoint(x: 0, y: 0)
        drawingLayer.opacity = 0.5
        
        pathLayer = drawingLayer
        self.view.layer.addSublayer(pathLayer)
    }
    
    fileprivate func animateRocket(_ rocket: inout Rocket) {
        let rocketView = UIImageView(image: UIImage(named: "1"))
        rocketView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rocketView.image!.size.width/5, height: rocketView.image!.size.height/5))
        rocketView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - rocketView.image!.size.height/8)
        
        let boomView = UIImageView(image: UIImage(named: "2"))
        boomView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: boomView.image!.size.width/4, height: boomView.image!.size.height/4))
        boomView.center = CGPoint(x: rocket.faceLayer.frame.origin.x + rocket.faceLayer.frame.size.width/2, y: rocket.faceLayer.frame.origin.y + rocket.faceLayer.frame.size.height/2-50)
        boomView.alpha = 0
        boomView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        view.addSubview(rocketView)
        view.addSubview(boomView)
        
        rocket.rocket = rocketView
        rocket.boom = boomView
        
        let distance = view.frame.size.width / min(rocket.faceLayer.frame.size.width, rocket.faceLayer.frame.size.height)
        let duration = Double(distance) * 0.45
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            rocketView.center = boomView.center
        }) { (_) in
            rocketView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                boomView.alpha = 1
                boomView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                    boomView.alpha = 0
                    boomView.transform = CGAffineTransform(scaleX: 2, y: 2)
                }, completion: { (_) in
                    
                })
            })
        }
    }
    
    fileprivate func reloadRocketAnimate() {
        for rocket in rockets {
            let distance = view.frame.size.width / min(rocket.faceLayer.frame.size.width, rocket.faceLayer.frame.size.height)
            let duration = Double(distance) * 0.45
            
            if let rocketView = rocket.rocket,
               let boomView = rocket.boom {
                UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
                    rocketView.center = rocket.faceLayer.frame.origin
                    boomView.center = rocket.faceLayer.frame.origin
                })
            }
        }
    }
    
    fileprivate func createVisionRequests() -> [VNRequest] {
        var requests: [VNRequest] = []
        requests.append(self.faceDetectionRequest)
        return requests
    }
    
    fileprivate func performVisionRequest(pixelBuffer: CVPixelBuffer, orientation: CGImagePropertyOrientation) {
        let requests = createVisionRequests()
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch {
                print("Failed to perform image request: \(error)")
                print("Image Request Failed: \(error)")
            }
        }
    }
    
    fileprivate func handleDetectedFaces(request: VNRequest?, error: Error?) {
        if let nsError = error as NSError? {
            print("Face Detection Error: \(nsError)")
            return
        }
        
        DispatchQueue.main.async {
            guard let drawLayer = self.pathLayer,
                  let results = request?.results as? [VNFaceObservation] else {
                return
            }
            
            self.draw(faces: results, onImageWithBounds: drawLayer.bounds)
            drawLayer.setNeedsDisplay()
        }
    }
    
    fileprivate func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        var rect = forRegionOfInterest
        
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
    
    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.fillColor = nil
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 2
        
        layer.borderColor = color.cgColor
        
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        return layer
    }
    
    fileprivate func draw(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
        for i in 0..<faces.count {
            let faceBox = boundingBox(forRegionOfInterest: faces[i].boundingBox, withinImageBounds: bounds)
            let faceLayer = shapeLayer(color: .yellow, frame: faceBox)
            
            if rockets.count != faces.count {
                rockets.append(Rocket(faceLayer: faceLayer))
            } else {
                rockets[i].faceLayer = faceLayer
            }
            
            //pathLayer?.addSublayer(faceLayer)
        }
        CATransaction.commit()
        reloadRocketAnimate()
    }
    
}

extension Task2ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        performVisionRequest(pixelBuffer: pixelBuffer, orientation: .leftMirrored)
    }
    
}
