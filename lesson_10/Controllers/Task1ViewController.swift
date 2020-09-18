//
//  Task1ViewController.swift
//  lesson_10
//
//  Created by Oleksandr Karpenko on 17.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

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
        
        LocationManager.shared.requestAccess(completion: nil)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        places.forEach { place in
            let marker = GMSMarker(position: place.coordinate)
            marker.title = place.title
            marker.snippet = place.subtitle
            
            if let icon = UIImage(named: "\(indexImage)") {
                marker.icon = icon
                indexImage += 1
            }
            
            marker.map = mapView
            indexImage += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRegion(center: calculateCenter())
    }
    
    @IBAction func userCurrentLocation(_ sender: Any) {
        LocationManager.shared.getLocation { location in
            self.setRegion(center: location!)
        }
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let regionRadius: Float = 13
        mapView.camera = GMSCameraPosition(target: center, zoom: regionRadius)
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

fileprivate class Place {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}

