//
//  Task2ViewController.swift
//  lesson_10
//
//  Created by Oleksandr Karpenko on 18.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import YandexMapKit

class Task2ViewController: UIViewController {
    
    @IBOutlet weak var mapView: YMKMapView!
    
    var indexImage = 1
    
    private let places: [Place] = [
        Place(coordinate: YMKPoint(latitude: 50.508723, longitude: 30.230401), title: "Central Park", subtitle: "Центральный парк"),
        Place(coordinate: YMKPoint(latitude: 50.518379, longitude: 30.232112), title: "Neznayka Park", subtitle: "Парк Незнайко"),
        Place(coordinate: YMKPoint(latitude: 50.513138, longitude: 30.257216), title: "Набережна Ірпеня", subtitle: "Набережна Ірпеня"),
        Place(coordinate: YMKPoint(latitude: 50.519171, longitude: 30.242026), title: "City center", subtitle: "Центр города"),
        Place(coordinate: YMKPoint(latitude: 50.540423, longitude: 30.252284), title: "Ирпенский пляж", subtitle: "Ирпенский пляж")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.requestAccess(completion: nil)
        
        places.forEach { place in
            mapView.mapWindow.map.mapObjects
                .addPlacemark(with: place.coordinate, image: UIImage(named: "\(indexImage)")!)
                .addTapListener(with: self)
            
            indexImage += 1
        }
        
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRegion(center: calculateCenter())
    }
    
    @IBAction func userCurrentLocation(_ sender: Any) {
        LocationManager.shared.getLocation { location in
            self.setRegion(center: YMKPoint(latitude: location!.latitude, longitude: location!.longitude))
        }
    }
    
    func setRegion(center: YMKPoint) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: center, zoom: 13, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
    }
    
    func calculateCenter() -> YMKPoint {
        let centerX = places.reduce(0.0, { $0 + $1.coordinate.latitude }) / Double(places.count)
        let centerY = places.reduce(0.0, { $0 + $1.coordinate.longitude }) / Double(places.count)
        return YMKPoint(latitude: centerX, longitude: centerY)
    }
    
}

extension Task2ViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print("123")
        return true
    }
}

fileprivate class Place {
    
    var coordinate: YMKPoint
    var title: String?
    var subtitle: String?
    
    init(coordinate: YMKPoint, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}
