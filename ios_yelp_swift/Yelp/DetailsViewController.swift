//
//  DetailsViewController.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business!
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = business.name
        ratingImageView.setImageWith(business.ratingImageURL!)
        reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = business.address
        categoriesLabel.text = business.categories
        
        mapView.delegate = self
        
        let centerLocation = CLLocation(latitude: business.latitude!, longitude: business.longitude!)
        goToLocation(location: centerLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)

        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.pinTintColor = UIColor(red:0.74, green:0.11, blue:0.00, alpha:1.0)
        print("green annotation should show")
        
        return annotationView
    }

}
