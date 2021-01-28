//
//  InformationConfirmingViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 23/01/21.
//

import UIKit
import MapKit

class InformationConfirmingViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - UI Controls
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: - Properties
    
    private var presentingController: UIViewController?
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var mapString: String = ""
    var mediaURL: String = ""
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        showMapAnnotation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingController = presentingViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.mapView.alpha = 1.0
        })
    }
        
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: - Actions
    
    @IBAction func finishButtonAction(_ sender: Any) {
        UdacityClient.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
    }
    
    // MARK: - Main methods
    
    func showMapAnnotation() {
        let latitude = CLLocationDegrees(self.latitude)
        let longitude = CLLocationDegrees(self.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.mapString

        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func handlePublicUserData(firstName: String?, lastName: String?, error: Error?) {
        if error == nil {
            UdacityClient.postStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.mapString, mediaURL: self.mediaURL, latitude: self.latitude, longitude: self.longitude, completion: handlePostStudentResponse(success:error:))
        } else {
            showFailure(title: "Not Possible to Get User Information", message: error?.localizedDescription ?? "")
        }
    }
    
    func handlePostStudentResponse(success: Bool, error: Error?) {
        if success {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            showFailure(title: "Not Possible to Save Information", message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
