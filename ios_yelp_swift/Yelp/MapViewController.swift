//
//  MapViewController.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        // Set up center location
        let centerLocation = CLLocation(latitude: businesses[0].latitude!, longitude: businesses[0].longitude!)
        goToLocation(location: centerLocation)
        
        for business in businesses {
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            mapView.addAnnotation(annotation)
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
}
