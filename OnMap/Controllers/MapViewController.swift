//
//  MapViewController.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/28/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import UIKit
import MapKit

// TODO: set pins on Map!

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - variables
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadStudentPins()
    }
    

    // MARK: - private methods
    
    func loadStudentPins() {
        self.activityIndicator.startAnimating()
        Client.getStudentLocations() { locations, error in
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.locations = locations ?? []
            for dictionary in locations ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    

    // MARK: - MKMapView Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = K.PinReuseId
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        loadStudentPins()
    }
}
