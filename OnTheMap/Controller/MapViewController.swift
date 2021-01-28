//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 13/01/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - UI Controls
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    // Add it to the studentLocations array in the Application Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    // MARK: - Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UdacityClient.getStudentLocations(completion: handleStudentLocationsResponse(locations:error:))
    }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        refreshButton.isEnabled = false
        UdacityClient.getStudentLocations(completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func addLocationButtonAction(_ sender: Any) {
        let informationPostingViewController = storyboard?.instantiateViewController(withIdentifier: "InformationPostingViewController") as! InformationPostingViewController
        present(informationPostingViewController, animated: true, completion: nil)
    }
    
    // MARK: - Main methods
    
    func showMapAnnotations(_ locations: [StudentLocation]) {
        var annotations = [MKPointAnnotation]()
               
        for location in locations {
            let latitude = CLLocationDegrees(location.latitude)
            let longitude = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        refreshButton.isEnabled = true
        
        if error == nil {
            if self.mapView.annotations.count > 0 {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            appDelegate.studentLocations = locations
            showMapAnnotations(locations)
        } else {
            showFailure(title: "Get Student Locations Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showFailure(title: "Logout Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
