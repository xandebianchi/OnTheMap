//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 18/01/21.
//

import UIKit
import CoreLocation
import Foundation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackViewCentral: UIStackView!
    @IBOutlet weak var imageAddLocation: UIImageView!

    private var presentingController: UIViewController?
    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    override func viewDidLoad() {
        locationTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingController = presentingViewController
    }
       
    @IBAction func findLocationButtonAction(_ sender: Any) {
        if locationTextField.text!.isEmpty || urlTextField.text!.isEmpty {
            showFailure(title: "Information Missing", message: "Please fill the location and the link or information associated.")
        } else {
            setIndicator(true)
            geocoder.geocodeAddressString(locationTextField.text ?? "") { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
    }
        
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            setIndicator(false)
            showFailure(title: "Location Do Not Exist", message: "The informed location doesn't exist.")
        } else {
            if let placemarks = placemarks, placemarks.count > 0 {
                let location = (placemarks.first?.location)! as CLLocation

                let coordinate = location.coordinate
                
                self.latitude = Float(coordinate.latitude)
                self.longitude = Float(coordinate.longitude)
                print("Coordinates: \(coordinate.latitude), \(coordinate.longitude)")
                                
                setIndicator(false)
                
                performSegue(withIdentifier: "goToConfirmingSegue", sender: self)
            } else {
                setIndicator(false)
                showFailure(title: "Location Not Well Specified", message: "Try to use the full location name (Ex: California, USA).")
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
                
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
