//
//  PinViewController.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/30/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    
    // MARK: - variables
    
    var studentInformation: StudentInformation?
    

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let studentLocation = studentInformation {
            let studentLocation = Location(
                createdAt: studentLocation.createdAt ?? "",
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showLocations(location: studentLocation)
        }
    }
    
    


    private func showLocations(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(false, button: self.finishButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.finishButton)
            }
        }
        DispatchQueue.main.async {
            self.finishButton.isEnabled = !loading
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func finishAddLocation(_ sender: UIButton) {
        self.setLoading(true)
        if let studentLocation = studentInformation {
            if Client.Auth.objectId == "" {
                    Client.addLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                self.setLoading(false)
                            }
                        }
                    }
            } else {
                let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite this location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    Client.updateLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                self.setLoading(false)
                            }
                        }
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        self.setLoading(false)
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alertVC, animated: true)
            }
        }
    }
}
