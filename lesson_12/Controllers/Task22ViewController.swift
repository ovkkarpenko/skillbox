////
////  Task2ViewController.swift
////  lesson_12
////
////  Created by Oleksandr Karpenko on 21.09.2020.
////
//
//import UIKit
//import AVFoundation
//import Vision
//
//class Task22ViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    var pathLayer: CALayer?
//    var previewLayer: AVCaptureVideoPreviewLayer!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .photo
//
//        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let input = try? AVCaptureDeviceInput(device: captureDevice) else { return}
//
//        captureSession.addInput(input)
//        captureSession.startRunning()
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//
//        captureSession.addOutput(dataOutput)
//
//        pathLayer?.removeFromSuperlayer()
//        pathLayer = nil
//
//        let drawingLayer = CALayer()
//        drawingLayer.backgroundColor = UIColor.black.cgColor
//        drawingLayer.bounds = CGRect(x: 0, y: 0, width: previewLayer.frame.width, height: previewLayer.frame.height)
//        drawingLayer.anchorPoint = CGPoint.zero
//        drawingLayer.position = CGPoint(x: 0, y: 0)
//        drawingLayer.opacity = 0.5
//        pathLayer = drawingLayer
//
//        self.view.layer.addSublayer(pathLayer!)
//    }
//
//    @IBAction func takePicture(_ sender: Any) {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            presentPhotoPicker(sourceType: .photoLibrary)
//            return
//        }
//
//        let photoSourcePicker = UIAlertController()
//        let takePhoto = UIAlertAction(title: "Take photo", style: .default) { [unowned self] _ in
//            self.presentPhotoPicker(sourceType: .camera)
//        }
//        let choosePhoto = UIAlertAction(title: "Choose photo", style: .default) { [unowned self] _ in
//            self.presentPhotoPicker(sourceType: .photoLibrary)
//        }
//
//        photoSourcePicker.addAction(takePhoto)
//        photoSourcePicker.addAction(choosePhoto)
//        photoSourcePicker.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil))
//
//        present(photoSourcePicker, animated: true)
//    }
//
//    func scaleAndOrient(image: UIImage) -> UIImage {
//        let maxResolution: CGFloat = 640
//
//        guard let cgImage = image.cgImage else {
//            print("UIImage has no CGImage backing it!")
//            return image
//        }
//
//        let width = CGFloat(cgImage.width)
//        let height = CGFloat(cgImage.height)
//        var transform = CGAffineTransform.identity
//
//        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
//
//        if width > maxResolution ||
//            height > maxResolution {
//            let ratio = width / height
//            if width > height {
//                bounds.size.width = maxResolution
//                bounds.size.height = round(maxResolution / ratio)
//            } else {
//                bounds.size.width = round(maxResolution * ratio)
//                bounds.size.height = maxResolution
//            }
//        }
//
//        let scaleRatio = bounds.size.width / width
//        let orientation = image.imageOrientation
//        switch orientation {
//        case .up:
//            transform = .identity
//        case .down:
//            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
//        case .left:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
//        case .right:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
//        case .upMirrored:
//            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
//        case .downMirrored:
//            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
//        case .leftMirrored:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
//        case .rightMirrored:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
//        default:
//            fatalError()
//        }
//
//        return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
//            let context = rendererContext.cgContext
//
//            if orientation == .right || orientation == .left {
//                context.scaleBy(x: -scaleRatio, y: scaleRatio)
//                context.translateBy(x: -height, y: 0)
//            } else {
//                context.scaleBy(x: scaleRatio, y: -scaleRatio)
//                context.translateBy(x: 0, y: -height)
//            }
//            context.concatenate(transform)
//            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//        }
//    }
//
//
//    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = sourceType
//        present(picker, animated: true)
//    }
//
//    func show(_ image: UIImage) {
//        pathLayer?.removeFromSuperlayer()
//        pathLayer = nil
//        imageView.image = nil
//        imageView.image = image
//
//        let correctedImage = scaleAndOrient(image: image)
//        imageView.image = correctedImage
//
//        guard let cgImage = correctedImage.cgImage else {
//            print("Trying to show an image not backed by CGImage!")
//            return
//        }
//
//        let fullImageWidth = CGFloat(cgImage.width)
//        let fullImageHeight = CGFloat(cgImage.height)
//
//        let imageFrame = imageView.frame
//        let widthRatio = fullImageWidth / imageFrame.width
//        let heightRatio = fullImageHeight / imageFrame.height
//
//        let scaleDownRatio = max(widthRatio, heightRatio)
//
//        let imageWidth = fullImageWidth / scaleDownRatio
//        let imageHeight = fullImageHeight / scaleDownRatio
//
//        let xLayer = (imageFrame.width - imageWidth) / 2
//        let yLayer = imageView.frame.minY + (imageFrame.height - imageHeight) / 2
//        let drawingLayer = CALayer()
//        drawingLayer.backgroundColor = UIColor.black.cgColor
//        drawingLayer.bounds = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
//        drawingLayer.anchorPoint = CGPoint.zero
//        drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
//        drawingLayer.opacity = 0.5
//        pathLayer = drawingLayer
//        self.view.layer.addSublayer(pathLayer!)
//    }
//
//
//    lazy var faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleDetectedFaces)
//    lazy var faceLandmarkRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleDetectedFaceLandmarks)
//
//    fileprivate func createVisionRequests() -> [VNRequest] {
//        var requests: [VNRequest] = []
//
//        requests.append(self.faceDetectionRequest)
//        requests.append(self.faceLandmarkRequest)
//
//        return requests
//    }
//
//    fileprivate func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
//        let requests = createVisionRequests()
//        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try imageRequestHandler.perform(requests)
//            } catch {
//                print("Failed to perform image request: \(error)")
//                print("Image Request Failed: \(error)")
//            }
//        }
//    }
//
//    fileprivate func handleDetectedFaces(request: VNRequest?, error: Error?) {
//        if let nsError = error as NSError? {
//            print("Face Detection Error: \(nsError)")
//            return
//        }
//
//        DispatchQueue.main.async {
//            guard let drawLayer = self.pathLayer,
//                  let results = request?.results as? [VNFaceObservation] else {
//                return
//            }
//
//            self.draw(faces: results, onImageWithBounds: drawLayer.bounds)
//            drawLayer.setNeedsDisplay()
//        }
//    }
//
//    fileprivate func handleDetectedFaceLandmarks(request: VNRequest?, error: Error?) {
//        if let nsError = error as NSError? {
//            print("Face Landmark Detection Error: \(nsError)")
//            return
//        }
//
//        DispatchQueue.main.async {
//            guard let drawLayer = self.pathLayer,
//                  let results = request?.results as? [VNFaceObservation] else {
//                return
//            }
//
//            self.drawFeatures(faces: results, onImageWithBounds: drawLayer.bounds)
//            drawLayer.setNeedsDisplay()
//        }
//    }
//
//    fileprivate func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
//        let imageWidth = bounds.width
//        let imageHeight = bounds.height
//
//        var rect = forRegionOfInterest
//
//        rect.origin.x *= imageWidth
//        rect.origin.x += bounds.origin.x
//        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
//
//        rect.size.width *= imageWidth
//        rect.size.height *= imageHeight
//
//        return rect
//    }
//
//    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
//        let layer = CAShapeLayer()
//
//        layer.fillColor = nil
//        layer.shadowOpacity = 0
//        layer.shadowRadius = 0
//        layer.borderWidth = 2
//
//        layer.borderColor = color.cgColor
//
//        layer.anchorPoint = .zero
//        layer.frame = frame
//        layer.masksToBounds = true
//
//        layer.transform = CATransform3DMakeScale(1, -1, 1)
//
//        return layer
//    }
//
//
//    fileprivate func draw(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect) {
//        CATransaction.begin()
//        for observation in faces {
//            let faceBox = boundingBox(forRegionOfInterest: observation.boundingBox, withinImageBounds: bounds)
//            let faceLayer = shapeLayer(color: .yellow, frame: faceBox)
////            animateRocketTo(frame: faceBox)
//
//            pathLayer?.removeFromSuperlayer()
//            pathLayer = nil
//
//            let drawingLayer = CALayer()
//            drawingLayer.backgroundColor = UIColor.black.cgColor
//            drawingLayer.bounds = CGRect(x: previewLayer.position.x, y: previewLayer.position.y, width: previewLayer.frame.width, height: previewLayer.frame.height)
//            drawingLayer.anchorPoint = CGPoint.zero
//
//            let xLayer = (view.frame.width - view.frame.width) / 2
//            let yLayer = imageView.frame.minY + (view.frame.height - view.frame.height) / 2
//
//            drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
//            drawingLayer.opacity = 0.5
//            pathLayer = drawingLayer
//
//            self.view.layer.addSublayer(pathLayer!)
//
//            pathLayer?.addSublayer(faceLayer)
//        }
//        CATransaction.commit()
//    }
//
//    fileprivate func drawFeatures(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect) {
//        CATransaction.begin()
//        for faceObservation in faces {
//            let faceBounds = boundingBox(forRegionOfInterest: faceObservation.boundingBox, withinImageBounds: bounds)
//            guard let landmarks = faceObservation.landmarks else {
//                continue
//            }
//
//            let landmarkLayer = CAShapeLayer()
//            let landmarkPath = CGMutablePath()
//            let affineTransform = CGAffineTransform(scaleX: faceBounds.size.width, y: faceBounds.size.height)
//
//            let openLandmarkRegions: [VNFaceLandmarkRegion2D?] = [
//                landmarks.leftEyebrow,
//                landmarks.rightEyebrow,
//                landmarks.faceContour,
//                landmarks.noseCrest,
//                landmarks.medianLine
//            ]
//
//            let closedLandmarkRegions = [
//                landmarks.leftEye,
//                landmarks.rightEye,
//                landmarks.outerLips,
//                landmarks.innerLips,
//                landmarks.nose
//            ].compactMap { $0 }
//
//            for openLandmarkRegion in openLandmarkRegions where openLandmarkRegion != nil {
//                landmarkPath.addPoints(in: openLandmarkRegion!, applying: affineTransform, closingWhenComplete: false)
//            }
//
//            for closedLandmarkRegion in closedLandmarkRegions {
//                landmarkPath.addPoints(in: closedLandmarkRegion, applying: affineTransform, closingWhenComplete: true)
//            }
//
//            landmarkLayer.path = landmarkPath
//            landmarkLayer.lineWidth = 2
//            landmarkLayer.strokeColor = UIColor.green.cgColor
//            landmarkLayer.fillColor = nil
//            landmarkLayer.shadowOpacity = 0.75
//            landmarkLayer.shadowRadius = 4
//
//            landmarkLayer.anchorPoint = .zero
//            landmarkLayer.frame = faceBounds
//            landmarkLayer.transform = CATransform3DMakeScale(1, -1, -1)
//
//            pathLayer?.addSublayer(landmarkLayer)
//        }
//        CATransaction.commit()
//    }
//
//    fileprivate func animateRocketTo(frame: CGRect) {
//        let rocket = UIImageView(image: UIImage(named: "1"))
//        rocket.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rocket.image!.size.width/5, height: rocket.image!.size.height/5))
//        rocket.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - rocket.image!.size.height/8)
//
//        let boom = UIImageView(image: UIImage(named: "2"))
//        boom.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: boom.image!.size.width/4, height: boom.image!.size.height/4))
//        boom.center = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2-50)
//        boom.alpha = 0
//        boom.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//
//        view.addSubview(rocket)
//        view.addSubview(boom)
//
//        let distance = view.frame.size.width / min(frame.size.width, frame.size.height)
//        let duration = Double(distance) * 0.2
//
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
//            rocket.center = boom.center
//        }) { (_) in
//            rocket.alpha = 0
//            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
//                boom.alpha = 1
//                boom.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }, completion: { (_) in
//                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
//                    boom.alpha = 0
//                    boom.transform = CGAffineTransform(scaleX: 2, y: 2)
//                }, completion: { (_) in
//
//                })
//            })
//        }
//    }
//
//    func inferOrientation(image: UIImage) -> CGImagePropertyOrientation {
//        switch image.imageOrientation {
//        case .up:
//            return CGImagePropertyOrientation.up
//        case .upMirrored:
//            return CGImagePropertyOrientation.upMirrored
//        case .down:
//            return CGImagePropertyOrientation.down
//        case .downMirrored:
//            return CGImagePropertyOrientation.downMirrored
//        case .left:
//            return CGImagePropertyOrientation.left
//        case .leftMirrored:
//            return CGImagePropertyOrientation.leftMirrored
//        case .right:
//            return CGImagePropertyOrientation.right
//        case .rightMirrored:
//            return CGImagePropertyOrientation.rightMirrored
//        }
//    }
//
//}
//
//extension Task22ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//
//        let requests = createVisionRequests()
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try imageRequestHandler.perform(requests)
//            } catch {
//                print("Failed to perform image request: \(error)")
//                print("Image Request Failed: \(error)")
//            }
//        }
//    }
//
//}
//
//extension Task2ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        show(originalImage)
//
//        guard let cgImage = originalImage.cgImage else {
//            return
//        }
//
//        performVisionRequest(image: cgImage, orientation: inferOrientation(image: originalImage))
//
//        picker.dismiss(animated: true)
//    }
//
//}
//
//private extension CGMutablePath {
//    func addPoints(in landmarkRegion: VNFaceLandmarkRegion2D,
//                   applying affineTransform: CGAffineTransform,
//                   closingWhenComplete closePath: Bool) {
//        let pointCount = landmarkRegion.pointCount
//
//        guard pointCount > 1 else {
//            return
//        }
//        self.addLines(between: landmarkRegion.normalizedPoints, transform: affineTransform)
//
//        if closePath {
//            self.closeSubpath()
//        }
//    }
//}
