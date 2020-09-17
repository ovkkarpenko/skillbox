//
//  Task1ViewController.swift
//  lesson_10
//
//  Created by Oleksandr Karpenko on 17.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import GoogleMaps

class Task1ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var indexImage = 1
    
    private let places: [Place] = [
        Place(coordinate: CLLocationCoordinate2D(latitude: 50.508723, longitude: 30.230401), title: "Central Park", subtitle: "Центральный парк"),
        Place(coordinate: CLLocationCoordinate2D(latitude: 50.518379, longitude: 30.232112), title: "Neznayka Park", subtitle: "Парк Незнайко"),
        Place(coordinate: CLLocationCoordinate2D(latitude: 50.513138, longitude: 30.257216), title: "Набережна Ірпеня", subtitle: "Набережна Ірпеня"),
        Place(coordinate: CLLocationCoordinate2D(latitude: 50.519171, longitude: 30.242026), title: "City center", subtitle: "Центр города"),
        Place(coordinate: CLLocationCoordinate2D(latitude: 50.540423, longitude: 30.252284), title: "Ирпенский пляж", subtitle: "Ирпенский пляж")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        places.forEach { place in
            let marker = GMSMarker(position: place.coordinate)
            marker.title = place.title
            marker.snippet = place.subtitle
            marker.icon = UIImage(named: "\(indexImage)")
            marker.map = mapView
            indexImage += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRegion()
    }
    
    func setRegion() {
        let regionRadius: Float = 13
        let region = calculateCenter()
        mapView.camera = GMSCameraPosition(target: region, zoom: regionRadius)
    }
    
    func calculateCenter() -> CLLocationCoordinate2D {
        let centerX = places.reduce(0.0, { $0 + $1.coordinate.latitude }) / Double(places.count)
        let centerY = places.reduce(0.0, { $0 + $1.coordinate.longitude }) / Double(places.count)
        return CLLocationCoordinate2D(latitude: centerX, longitude: centerY)
    }

}

extension Task1ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.title ?? "")
        return true
    }
    
}
