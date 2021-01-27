//
//  InformationConfirmingViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 23/01/21.
//

import UIKit
import MapKit

class InformationConfirmingViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    private var presentingController: UIViewController?
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var mapString: String = ""
    var mediaURL: String = ""
    
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
    
    func showMapAnnotation() {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        // TODO Change explanation
        //var annotations = [MKPointAnnotation]()
               
        let latitude = CLLocationDegrees(self.latitude)
        let longitude = CLLocationDegrees(self.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //let firstName = location.firstName // as! String
        //let lastName = location.lastName // as! String
       // let mediaURL = location.mediaURL // as! String
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.mapString
        //annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
       // annotations.append(annotation)
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotation(annotation)
        
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func finishButtonAction(_ sender: Any) {
        UdacityClient.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
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
            self.presentingController?.view.isHidden = true
            self.dismiss(animated: true, completion: {
                self.presentingController?.dismiss(animated: false)
            })
        } else {
            showFailure(title: "Not Possible to Save Information", message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
