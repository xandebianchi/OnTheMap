//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 18/01/21.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackViewCentral: UIStackView!
    @IBOutlet weak var imageAddLocation: UIImageView!

    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    @IBAction func findLocationButtonAction(_ sender: Any) {
        //threatUIErrors()
        setIndicator(true)
        geocoder.geocodeAddressString(locationTextField.text ?? "") { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
        
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            // TODO Handle error
        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                
                self.latitude = Float(coordinate.latitude)
                self.longitude = Float(coordinate.longitude)
                print("Coordinates: \(coordinate.latitude), \(coordinate.longitude)")
                                
                setIndicator(false)
                
                performSegue(withIdentifier: "goToConfirmingSegue", sender: self)
            } else {
                setIndicator(false)
                
                print("No Matching Location Found")
            }
        }
    }
    
    func setIndicator(_ isFinding: Bool) {
        if isFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let informationConfirmingViewController = segue.destination as! InformationConfirmingViewController

        informationConfirmingViewController.latitude = self.latitude
        informationConfirmingViewController.longitude = self.longitude
        informationConfirmingViewController.mapString = self.locationTextField.text!
        informationConfirmingViewController.mediaURL = self.urlTextField.text!
    }
                
    //func threatUIErrors() {
    //}
    
}
