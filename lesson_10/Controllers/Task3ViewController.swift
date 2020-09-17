//
//  ViewController.swift
//  lesson_10
//
//  Created by Oleksandr Karpenko on 17.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import MapKit

class Task3ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        mapView.addAnnotations(places)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRegion()
    }
    
    func setRegion() {
        let regionRadius: CLLocationDistance = 5000
        let region = MKCoordinateRegion(center: calculateCenter(), latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func calculateCenter() -> CLLocationCoordinate2D {
        let centerX = places.reduce(0.0, { $0 + $1.coordinate.latitude }) / Double(places.count)
        let centerY = places.reduce(0.0, { $0 + $1.coordinate.longitude }) / Double(places.count)
        return CLLocationCoordinate2D(latitude: centerX, longitude: centerY)
    }
    
}

extension Task3ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Placemark"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "\(indexImage)")
            annotationView?.canShowCallout = true
            indexImage += 1
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title! ?? "")
    }
    
}

class Place: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}
