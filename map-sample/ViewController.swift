//
//  ViewController.swift
//  map-sample
//
//  Created by NhatPV on 09/06/2023.
//

import UIKit
import Mapbox

class ViewController: UIViewController {
    var mapView: MGLMapView!
    var coordinates: [CLLocationCoordinate2D] = []
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _,_ in
                DispatchQueue.main.async {
                    CLLocationManager().requestWhenInUseAuthorization()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startMapView()
        drawPolygon()
    }
    
    
    func startMapView() {
        mapView = MGLMapView(frame: view.bounds, styleURL: URL(string: "https://run.mocky.io/v3/2cdf49bc-40fe-4aa5-a992-1954c8fb298f"))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .follow
       
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(tap:)))
        mapView.gestureRecognizers?.filter({ $0 is UILongPressGestureRecognizer }).forEach(singleTap.require(toFail:))
        mapView.addGestureRecognizer(singleTap)
        view.addSubview(mapView)
    }
    
    func drawPolyline() {
        let polyline = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        mapView.addAnnotation(polyline)
    }
    
    func drawPolygon() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 10.745863, longitude: 106.655122),
            CLLocationCoordinate2D(latitude: 10.753557, longitude: 106.649735),
            CLLocationCoordinate2D(latitude: 10.765662, longitude: 106.681285),
            CLLocationCoordinate2D(latitude: 10.750961, longitude: 106.683948)
        ]
        let polygon = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))
        mapView.addAnnotation(polygon)
    }
    
    // MARK: Gesture Recognizer Handlers
    @objc func didLongPress(tap: UILongPressGestureRecognizer) {
        guard let mapView = mapView else { return }
        if (coordinates.isEmpty) {
            coordinates.append((mapView.userLocation?.location?.coordinate)!)
        }
        let point = mapView.convert(tap.location(in: mapView), toCoordinateFrom: mapView)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = point
        annotation.title = "Point Here"
        coordinates.append(point)
        mapView.addAnnotation(annotation)
        drawPolyline()
    }
}

extension ViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let image = UIImage(systemName: "car")!
        image.withTintColor(UIColor.red)
        let annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "customAnnotation")

        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let imageView = UIImageView(image: UIImage(named: "leftAccessoryImage"))
        return imageView
    }

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button = UIButton(type: .detailDisclosure)
        return button
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor.red.withAlphaComponent(0.5)
    }
}
